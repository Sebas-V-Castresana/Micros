#  Main Proyecto Final Micros
#  Controla la interfaz y actualiza los datos de la misma

import threading as th
import lgpio as pi
import GUI_Proyecto_Final_Micros as GUI
from datetime import datetime
from time import sleep

#  Variables globales
Adrs_ESP = 0x0a  # Address ESP32 para comunicacion I2C
Datos_ESP = bytearray(5)  # 0: Apilado, 1-3: C, B, P, 4: Exito o no
datos_leer = 5  # Cantidad de datos a leer del ESP
time_Grua = 10  # Tiempo que toma el protocolo de mover la grua
time_lectura = 2  # Tiempo entre pedirle datos al ESP
terminar_hilo = th.Event()  # Flag para terminar el thread de I2C
start_grua = th.Event()  # Flag para encender grua
stop_grua = th.Event()  # Flag para apagar grua
State = 0  # Flag para empezar/apagar el sistema 0: OFF, 1: ON
csv_datos = []  # Lista para guardar los datos del .csv
# Color default: bg = #1DB8C6 fg = black
# Color START: bg = #77EA60 fg = #26B210
# Color END: bg = #FC6666 fg = #FF3535
# Color GEN: bg = #1DB8A6 fg = black


def generarInforme(data: list = csv_datos):
    '''Funcion para generar el .csv'''
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
    pi.i2c_write_device(handle, datos)


def leerDatos(handle: int):
    ''' Funcion para leer datos del ESP'''
    global Datos_ESP
    while (True):
        pi.i2c_read_device(handle, datos_leer)
        _, Buffer = pi.i2c_read_device(handle, datos_leer)
        if (Buffer[0] == 6):  # En caso de que se encuentre actualizando datos
            sleep(time_lectura)
            continue

        else:  # De lo contrario guardo los datos donde corresponden
            Datos_ESP = Buffer
            break


# Funcion para leer el QR de las cajas de apilado
def Scan_QR() -> tuple:
    return 1


def check_cajas(handle: int) -> tuple:
    '''Funcion para revisar si se debe o no mover la grua'''
    # Primero lee los datos del ESP
    leerDatos(handle)
    if (Datos_ESP[0] > 0):  # Si existen cajas en la zona de apilado
        indice, tipo = Scan_QR()
        if (Datos_ESP[indice] == 5):  # Si hay 5 cajas, no mueve la grua
            while (True):
                print(f"Desocupe la zona de carga de {tipo} para continuar")
                sleep(time_lectura)
                leerDatos(handle)
                if (Datos_ESP[indice] < 5 and not stop_grua.is_set()):
                    break
                # Si se cierra el hilo o se cambia el estado sale de la funcion
                if terminar_hilo.is_set() or stop_grua.is_set():
                    return 0, 0, 0
        # Si se tienen menos de 5 cajas se mueve la caja a su zona
        enviarDatos(handle, [1, tipo, State])
        return 1, tipo, indice

    else:
        return 0, 0, 0


def main_I2C():
    '''Funcion principal thread de I2C
    Abre el bus I2C e inicia comunicacion con el ESP'''
    Handle_ESP = pi.i2c_open(1, Adrs_ESP)
    global csv_datos
    start_grua.wait()  # Se espera a que se inicie el sistema
    enviarDatos(Handle_ESP, [0, 0, State])
    while (True):
        # Manejo de hilo
        if terminar_hilo.is_set():
            pi.i2c_close(Handle_ESP)
            return 0

        # Manejo start/stop grua
        if stop_grua.is_set():
            enviarDatos(Handle_ESP, [0, 0, State])  # Envia cond. de paro
            start_grua.wait()  # Espera a volver a ser inicializado
            if not stop_grua.is_set():
                enviarDatos(Handle_ESP, [0, 0, State])  # Envia cond. de inicio
            else:
                continue

        # Manejo del inventario
        hay_cajas, tipo, indice = check_cajas(Handle_ESP)
        if (hay_cajas == 0 and tipo == 0 and indice == 0):
            continue

        if (hay_cajas == 0):  # Esperando el tiempo de lectura normal
            sleep(time_lectura)
            continue

        else:  # Esperando el tiempo de mov de la grua
            sleep(time_Grua)
            leerDatos(Handle_ESP)
            # Revisa el codigo de exito de la grua para asegurarse
            if (Datos_ESP[4] == 1):  # De ser exitoso guarda en los datos csv
                csv_datos.append([datetime.now().strftime("%d-%m-%Y %H:%M:%S"),
                                  tipo, str(Datos_ESP[indice])])

            elif (Datos_ESP[4] == 2):  # En caso de un error al mover la grua
                print("ERROR al mover la grua")
            continue


def Terminar(thread, master):
    '''Cierra el hilo I2C y destruye la ventana de control'''
    # En caso de que se encuentra apagado, se resetea el estado de la grua
    if stop_grua.is_set():
        start_grua.set()

    # Se procede a enviar la cond. de cierre al thread I2C
    terminar_hilo.set()
    thread.join()

    # Una vez se haya unido el thread I2C se cierra la interfaz grafica
    master.destroy()


def DataUpdate(master: GUI.ventana, delay: int):
    '''tk.after() para la ventana. delay: ms de delay,
    Data: Info a actualizar, 1: cafe, 2: banano, 3: pina'''
    global Datos_ESP
    master.cafe.configure(text='Cajas Cafe: ' + str(Datos_ESP[1]))
    master.banano.configure(text='Cajas Banano: ' + str(Datos_ESP[2]))
    master.pina.configure(text='Cajas Piña: ' + str(Datos_ESP[3]))
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
    hilo_I2C = th.Thread(main_I2C)
    hilo_I2C.start()

    # Creacion de interfaz grafica
    master = GUI.ventana()
    master.bind('<Escape>', lambda: Terminar(hilo_I2C, master))

    # Eventos
    master.bind('<Return>', lambda event: State_Grua('Start'))
    master.bind('<Shift-Key-Return>', lambda event: State_Grua('Stop'))
    master.bind('Alt-Key-Return>', lambda event: generarInforme())

    # Asignando funciones a los botones de la ventana
    master.Start.configure(command=lambda: State_Grua(master, 'Start'))
    master.End.configure(command=lambda: State_Grua(master, 'Stop'))
    master.Gen.configure(command=lambda: generarInforme())

    # Llamando la interfaz grafica y la funcion responsable de actualizar datos
    DataUpdate(master, 500)
    master.mainloop()
