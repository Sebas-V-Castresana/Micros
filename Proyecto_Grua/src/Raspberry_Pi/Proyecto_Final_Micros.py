
#   Main Proyecto Final Micros
#   Controla la interfaz y actualiza los datos de la misma

import threading as th
import GUI_Proyecto_Final_Micros as GUI
from datetime import datetime
from time import sleep
import cv2 
import numpy as np
from pyzbar.pyzbar import decode

#   Variables globales
Adrs_ESP = 0x0a   # Address ESP32 para comunicacion I2C
Datos_ESP = bytearray(5)  # 0: Apilado, 1-3: C, B, P, 4: Exito o no
datos_leer = 5    # Cantidad de datos a leer del ESP
time_Grua = 10    # Tiempo que toma el protocolo de mover la grua
time_lectura = 2  # Tiempo entre pedirle datos al ESP
terminar_hilo = th.Event()  # Flag para terminar el thread de I2C
terminar_camara = th.Event() # Flag para terminar el thread de la cámara
start_grua = th.Event()   # Flag para encender grua
stop_grua = th.Event()    # Flag para apagar grua
State = 0   # Flag para empezar/apagar el sistema 0: OFF, 1: ON
csv_datos = []    # Lista para guardar los datos del .csv
array_esp_anterior = [0,0,0] # Lista para guardar los datos del .csv parte 2

# Color default: bg = #1DB8C6 fg = black
# Color START: bg = #77EA60 fg = #26B210
# Color END: bg = #FC6666 fg = #FF3535
# Color GEN: bg = #1DB8A6 fg = black

# --- Variables globales para compartir el frame de la cámara ---
latest_frame = None
latest_frame_lock = th.Lock() # Mecanismo para proteger el acceso a 'latest_frame'

# --- NUEVAS VARIABLES GLOBALES PARA CONTROL DEL ESTADO DE LA GRÚA ---
crane_task_in_progress = False # True si la grúa está en medio de un ciclo de movimiento (Controlado por RPi)


class MockGPIO:
    def i2c_open(self, bus, addr):
        print(f"Mock: Abriendo bus I2C {bus} en dirección {addr}")
        return 1 # Devuelve un handle ficticio
    def i2c_write_device(self, handle, data):
        # print(f"Mock: Escribiendo {data} al handle I2C {handle}")
        pass
    def i2c_read_device(self, handle, num_bytes):
        print(f"Mock: Leyendo {num_bytes} bytes del handle I2C {handle}")
        # Simulación de Datos_ESP
        # En un escenario de mock más avanzado, aquí podrías simular respuestas del ESP
        # basadas en el estado de 'crane_task_in_progress'
        # Por ahora, simplemente devuelve el estado actual de Datos_ESP como si fuera leído.
        global Datos_ESP, crane_task_in_progress
        # Puedes añadir lógica de mock para Datos_ESP[4] aquí si quieres simular el fin de tarea
        # For example, if crane_task_in_progress is True, you might set Datos_ESP[4] to 0 for a few cycles
        # and then to 1 after 'time_Grua' has theoretically passed.
        
        # Una simulación simple: si el ESP no está "en progreso", puede devolver 1 para éxito
        # (Esto asume que el ESP va de 0->1->0 o 0->2->0. No es un mock completo del FSM del ESP)
        # if Datos_ESP[4] == 0 and crane_task_in_progress: # If RPi thinks it's in progress, but ESP says 0
        #     Datos_ESP[4] = 1 # Simulate success after some time/logic in the mock itself.
        # This requires more complex state management within the mock.

        return 0, bytearray([Datos_ESP[0], Datos_ESP[1], Datos_ESP[2], Datos_ESP[3], Datos_ESP[4]])

    def i2c_close(self, handle):
        print(f"Mock: Cerrando handle I2C {handle}")
        pass

try:
    import lgpio as pi
except ModuleNotFoundError:
    print("lgpio no encontrado, usando mock para pruebas.")
    pi = MockGPIO()


def generarInforme(data: list = csv_datos):
    '''Funcion para generar el .csv'''
    print("Generando CSV")
    if not data:
        print("No existen datos aun")
        return
    i = 1
    # Se crea el archivo .csv revisando que no se elimine un informe anterior
    while (1):
        try:
            nombre = "Informe_" + str(i) + ".csv"
            file = open(nombre, "x")
            file.close()
            break

        except FileExistsError:
            i += 1

    # Se escribe los nombres de las columnas
    with open(nombre, "a") as file:
        file.write("Fecha,Tipo de Caja,Cantidad Actual\n")

    # Ahora se escriben los datos del programa
    # entry[0]: fecha, entry[1]: tipo, entry[2]: cantidad
    for entry in data:
        with open(nombre, "a") as file:
            file.write(entry[0] + ",")
            file.write(entry[1] + ",")
            file.write(entry[2] + "\n")


def enviarDatos(handle: int, datos: list):
    '''Funcion para enviar datos al ESP'''
    # --- IMPRESIÓN DE DATOS ENVIADOS ---
    print(f"RPi -> ESP (Enviados): {datos}")
    # --- FIN IMPRESIÓN ---
    pi.i2c_write_device(handle, datos)


def leerDatos(handle: int):
    ''' Funcion para leer datos del ESP y actualizar Datos_ESP global'''
    global Datos_ESP
    _ , Buffer = pi.i2c_read_device(handle, datos_leer)
    
    # Si el ESP envía un '6' en Datos_ESP[4], significa que está en medio de la actualización
    # de sus datos de celdas de carga o de la FSM. La RPi debe esperar.
    if Buffer[4] == 6: # ESP está ocupado, reintentar en la próxima iteración.
        # No actualizar Datos_ESP ni imprimir, solo esperar un ciclo.
        print("RPi <- ESP: ESP ocupado (Estado 6). Reintentando en proxima iteración...")
        return False # Indicar que no se pudo leer datos válidos aún.
    else:
        Datos_ESP = Buffer
        print(f"RPi <- ESP (Recibidos): {list(Datos_ESP)}")
        return True # Indicar que se leyeron datos válidos.


# Funcion para leer el QR de las cajas de apilado
def Scan_QR(frame):
    """
    Escanea un fotograma en busca de códigos QR.
    Devuelve una lista de todos los objetos decodificados y el objeto QR con la coordenada 'y' más alta.

    Args:
        frame (numpy.ndarray): El fotograma de la cámara en el que buscar códigos QR.

    Returns:
        tuple: Una tupla que contiene:
               - list: Una lista de todos los objetos decodificados (códigos QR) encontrados.
               - pyzbar.Decoded or None: El objeto QR con la posición 'y' más alta, o None si no se encontraron QRs.
    """
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    decoded_objects = decode(gray)

    highest_qr = None
    min_y = float('inf') # Inicializa con un valor muy grande para encontrar la 'y' más pequeña (más alta en la imagen)

    for obj in decoded_objects:
        # obj.rect es un rectángulo con (left, top, width, height)
        # top es la coordenada 'y' de la parte superior del QR
        y = obj.rect.top
        if y < min_y:
            min_y = y
            highest_qr = obj
    
    return decoded_objects, highest_qr


def dibujar_qr(frame, qr, color=(255, 0, 0), thickness = 2):
    """
    Dibuja un polígono alrededor de un código QR detectado y muestra sus datos.

    Args:
        frame (numpy.ndarray): El fotograma en el que dibujar el código QR.
        obj (pyzbar.Decoded): El objeto Decoded que representa el código QR.
        color (tuple): El color del contorno y texto (B, G, R). Por defecto es verde.
        thickness (int): El grosor de la línea del contorno.
    """
    # Dibuja un polígono alrededor del código QR detectado
    points = qr.polygon
    if len(points) > 4:
        # pyzbar puede devolver más de 4 puntos si el QR está distorsionado
        hull = cv2.convexHull(np.array([point for point in points], dtype=np.float32))
        cv2.polylines(frame, [np.int32(hull)], True, color, thickness)
    else:
        cv2.polylines(frame, [np.int32(points)], True, color, thickness)

    # Agrega un texto con los datos decodificados
    x, y, w, h = qr.rect
    cv2.putText(frame, qr.data.decode('utf-8'), (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, thickness)



def main_I2C():
    '''Funcion principal thread de I2C
    Abre el bus I2C e inicia comunicacion con el ESP'''
    global csv_datos, crane_task_in_progress, Datos_ESP, array_esp_anterior

    _tipo_num = 0
    _tipo_str = ""
    
    Handle_ESP = pi.i2c_open(1, Adrs_ESP)
    
    # Al inicio, asegurar que la grúa está en reposo y enviar señal de 0.
    array_to_esp = [0, 0]
    enviarDatos(Handle_ESP, array_to_esp)
    print("Esperando señal 'START' de la GUI para iniciar operaciones de grúa...")
    start_grua.wait() # Esperar a que la GUI active el sistema

    while (True):
        # Manejo de terminación del hilo
        if terminar_hilo.is_set():
            pi.i2c_close(Handle_ESP)
            print("Hilo I2C terminado.")
            return 0
        
        read_successful = leerDatos(Handle_ESP)
        if not read_successful:
            sleep(time_lectura)


        # Manejo de pausa/reinicio del sistema desde la GUI (botón END)
        if stop_grua.is_set():
            array_to_esp[0] = 0
        
        elif start_grua.is_set():
            if Datos_ESP[_tipo_num] != 5:
                array_to_esp[0] = 1
                print(f"ATENCIÓN: Zona de carga de {_tipo_str} (tipo {_tipo_num}) está llena (5 cajas).")
                print("No se iniciará movimiento debido a destino lleno.")
        
        qrs, qr_mas_alto = Scan_QR(latest_frame)
        try: 
            if(qr_mas_alto):
                qr_obj = int(qr_mas_alto.data.decode('utf-8'))
                
                try:
                    if qr_obj in [1, 2, 3]:
                        array_to_esp[1] = qr_obj
                        _tipo_num = qr_obj
                        if _tipo_num == 1: _tipo_str = "Cafe"
                        elif _tipo_num == 2: _tipo_str = "Banano"
                        elif _tipo_num == 3: _tipo_str = "Disp.M"
                    else:
                        array_to_esp[1] = 0
                        print(f"QR detectado '{qr_obj}' no es 1, 2 o 3.")
                except ValueError:
                    array_to_esp[1] = 0
                    print(f"Contenido del QR '{qr_info_str}' no es un número.")
        except:
            array_to_esp[1] = 0
            print("No se detectó ningún QR válido.")
        
        if (array_esp_anterior[0] != Datos_ESP[1]):
            csv_datos.append([datetime.now().strftime("%d-%m-%Y %H:%M:%S"),"Cafe", str(Datos_ESP[1])])
            array_esp_anterior[0] = Datos_ESP[1]
        elif (array_esp_anterior[1] != Datos_ESP[2]):
            csv_datos.append([datetime.now().strftime("%d-%m-%Y %H:%M:%S"),"Banano", str(Datos_ESP[2])])
            array_esp_anterior[1] = Datos_ESP[2]
        elif (array_esp_anterior[2] != Datos_ESP[3]):
            csv_datos.append([datetime.now().strftime("%d-%m-%Y %H:%M:%S"),"Disp.M", str(Datos_ESP[3])])
            array_esp_anterior[2] = Datos_ESP[3]
        




        enviarDatos(Handle_ESP, array_to_esp)


# --- FUNCIÓN PARA EL HILO DE LA CÁMARA ---
def camera_thread_function():
    global latest_frame, latest_frame_lock, crane_task_in_progress, \
           last_successful_tipo_num, last_successful_tipo_str # Added these to global

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Error: No se pudo abrir la cámara.")
        terminar_camara.set()
        return

    print("Hilo de la cámara iniciado.")
    while not terminar_camara.is_set():
        ret, frame = cap.read()
        if not ret:
            print("Error: No se pudo acceder a la cámara o el stream terminó.")
            break

        with latest_frame_lock:
            latest_frame = frame.copy()

        # Solo escanear QR si NO hay una tarea de grúa en progreso.
        # Esto evita que el escáner intente detectar nuevos QRs
        # mientras la grúa está ocupada con uno anterior.
        if not crane_task_in_progress:
            qrs, qr_mas_alto = Scan_QR(frame) # Changed from Scan_QR to scan_qr for consistency
            # El QR detectado se usa en determine_potential_new_task
            # La visualización en la ventana de la cámara aún puede ocurrir.
        else:
            # Si hay una tarea en progreso, no escanear, pero aún dibujar el último frame.
            # Y si el último QR detectado (last_successful_tipo_num) existe,
            # podemos "dibujarlo" en el frame para indicar la tarea actual.
            qrs = [] # No hay QRs nuevos detectados
            qr_mas_alto = None # No hay un nuevo QR más alto

            # Opcional: Dibujar el QR de la tarea actual en la ventana de la cámara
            if last_successful_tipo_num != 0:
                # Simular un QR para dibujar, usando el tipo numérico guardado.
                # Nota: Esto es solo visual y no implica un escaneo real.
                # No tenemos las 'corners' originales, así que lo dibujaremos en un lugar fijo
                # o puedes modificar 'dibujar_qr' para que acepte una posición fija.
                # Por simplicidad, no dibujaremos el QR si no hay uno real detectado,
                # solo evitaremos el escaneo. Si quieres mostrar el tipo de caja actual,
                # podrías añadir un texto simple en la esquina de la ventana de la cámara.
                font = cv2.FONT_HERSHEY_SIMPLEX
                text = f"Movimiento: {last_successful_tipo_str}"
                cv2.putText(frame, text, (10, 30), font, 0.7, (255, 255, 255), 2, cv2.LINE_AA)
                cv2.putText(frame, "(Grúa en proceso)", (10, 60), font, 0.5, (255, 255, 255), 1, cv2.LINE_AA)


        for qr_obj in qrs: # Changed 'qr' to 'qr_obj' to avoid confusion, it is a pyzbar.Decoded object
            color = (255, 0, 0) # Default color
            
            # Compare the pyzbar.Decoded objects directly for equality
            if qr_mas_alto is not None and qr_obj == qr_mas_alto: 
                color = (0, 255, 0) # Highlight color for the highest QR
            
            dibujar_qr(frame, qr_obj, color=color) # Removed 'etiqueta' parameter as it's not in dibujar_qr's definition

        cv2.imshow("Deteccion QR sin pyzbar", frame) # Consider changing the window name, as pyzbar is used

        if cv2.waitKey(1) & 0xFF == ord('q'):
            terminar_camara.set()
            break
            
    cap.release()
    cv2.destroyAllWindows()
    print("Hilo de la cámara terminado.")


def Terminar(thread_i2c, thread_camera, master):
    '''Cierra los hilos y destruye la ventana de control'''
    if stop_grua.is_set():
        start_grua.set()

    terminar_hilo.set() 
    terminar_camara.set() 

    print("Cerrando hilos...")
    if thread_i2c.is_alive():
        thread_i2c.join()
    if thread_camera.is_alive():
        thread_camera.join()
    print("Hilos cerrados.")

    master.destroy()


def DataUpdate(master: GUI.ventana, delay: int):
    '''tk.after() para la ventana. delay: ms de delay,
    Data: Info a actualizar, 1: cafe, 2: banano, 3: pina'''
    global Datos_ESP
    master.cafe.configure(text='Cajas Disp.M: ' + str(Datos_ESP[3]))
    master.banano.configure(text='Cajas Banano: ' + str(Datos_ESP[2]))
    master.pina.configure(text='Cajas Cafe: ' + str(Datos_ESP[1]))
    master.after(delay, lambda: DataUpdate(master, delay))


def State_Grua(master: GUI.ventana, command: str):
    '''Inicia o termina el movimiento de la grua'''
    global State
    if (command == 'Start' and State == 0):
        State = 1
        stop_grua.clear()
        start_grua.set()
        master.Start.configure(bg='#77EA60', fg='#26B210')
        master.End.configure(bg='#1DB8C6', fg='black')
        master.update()
    elif (command == 'Stop' and State == 1):
        State = 0
        start_grua.clear()
        stop_grua.set()
        master.End.configure(bg='#FC6666', fg='#FF3535')
        master.Start.configure(bg='#1DB8C6', fg='black')
        master.update()


def main():
    '''Funcion principal del programa del proyecto'''

    # Creacion del hilo de I2C
    hilo_I2C = th.Thread(target=main_I2C, daemon=True)
    hilo_I2C.start()

    # Creacion del hilo de la cámara
    hilo_camara = th.Thread(target=camera_thread_function, daemon=True)
    hilo_camara.start()

    # Creacion de interfaz grafica
    master = GUI.ventana()
    master.bind('<Escape>', lambda event: Terminar(hilo_I2C, hilo_camara, master))


    # Eventos (bindings)
    master.bind('<Return>', lambda event: State_Grua(master, 'Start'))
    master.bind('<Shift-Key-Return>', lambda event: State_Grua(master, 'Stop'))
    master.bind('<Alt-Key-Return>', lambda event: generarInforme())

    # Asignando funciones a los botones de la ventana
    master.Start.configure(command=lambda: State_Grua(master, 'Start'))
    master.End.configure(command=lambda: State_Grua(master, 'Stop'))
    master.Gen.configure(command=lambda: generarInforme())

    # Llamando la interfaz grafica y la funcion responsable de actualizar datos
    DataUpdate(master, 500)
    # Corre la interfaz gráfica en el hilo principal
    master.mainloop()

    # Al salir de master.mainloop(), significa que la GUI se cerró.
    # Aseguramos que los hilos se cierren si no lo han hecho ya.
    terminar_hilo.set()
    terminar_camara.set()

    # Esperar a que los hilos terminen antes de que el programa principal salga
    if hilo_I2C.is_alive():
        hilo_I2C.join()
    if hilo_camara.is_alive():
        hilo_camara.join()
    print("Programa principal terminado.")




if __name__ == "__main__":
    main()
