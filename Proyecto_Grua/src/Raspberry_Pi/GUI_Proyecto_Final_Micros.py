# GUI del proyecto de Micros
# Crea la interfaz que se usa para controlar el proyecto
import tkinter as tk

Font = 'Helvetica 30'
Datos_ESP = bytearray(5)


class ventana(tk.Tk):
    '''Crea la ventana que se usa para la GUI'''
    def __init__(self):
        tk.Tk.__init__(self)
        self.geometry('950x700+250+50')
        self.configure(bg='#D9DEDF')
        self.resizable(False, False)
        #self.iconbitmap('Icono.ico')
        self.title("Interfaz de Control - Grua")
        self.Start, self.End, self.Gen = self.buttonSetup()
        self.cafe, self.banano, self.pina = self.labelSetup()

    def buttonMaker(self, texto, bg, ag, fg, af, x, y, h, w):
        boton = tk.Button(self, text=texto, bg=bg, activebackground=ag, fg=fg,
                          font=Font, height=h, width=w, activeforeground=af)
        boton.place(x=x, y=y)
        return boton

    def buttonSetup(self):
        # Start button
        Start = self.buttonMaker('START', '#1DB8C6', '#77EA60', 'black',
                                 '#26B210', 250, 200, 2, 20)

        # End button
        End = self.buttonMaker('END', '#1DB8C6', '#FC6666', 'black',
                               '#FF3535', 250, 350, 2, 20)

        # Generar button
        Gen = self.buttonMaker('GENERAR', '#1DB8C6', '#1DB8A6', 'black',
                               'black', 250, 500, 2, 20)

        # Eventos
        self.bind('<Return>', lambda event: Press('START'))
        self.bind('<Shift-Key-Return>', lambda event: Press('END'))
        self.bind('<Alt-Key-Return>', lambda event: Press('GENERAR'))

        return Start, End, Gen

    def labelSetup(self):
        # label Bienvenido
        titulo = tk.Label(self, font='Helvetica 80',
                          text='Bienvenido', bg='#D9DEDF', fg='black')
        titulo.place(x=220, y=50)

        # labels cajas
        cafe = tk.Label(self, font=Font, text='Cajas Disp.M: 0',
                        bg='#D9DEDF', fg='black')
        banano = tk.Label(self, font=Font, text='Cajas Banano: 0',
                          bg='#D9DEDF', fg='black')
        pina = tk.Label(self, font=Font, text='Cajas Cafe 0',
                        bg='#D9DEDF', fg='black')
        cafe.place(x=650, y=650)
        banano.place(x=325, y=650)
        pina.place(x=50, y=650)

        return cafe, banano, pina


def Press(boton, master):
    if boton == 'START':
        print('EMPEZAR FUNCION')
        master.Start.configure(bg='#77EA60', fg='#26B210')
        master.End.configure(bg='#1DB8C6', fg='black')
        master.update()

    elif boton == 'END':
        print('TERMINAR FUNCION')
        master.End.configure(bg='#FC6666', fg='#FF3535')
        master.Start.configure(bg='#1DB8C6', fg='black')
        master.update()

    elif boton == 'GENERAR':
        print('GENERAR INFORME')


def CountUpdate(source, cantidad):
    match(source):
        case 'cafe':
            cafe = 'Cajas Cafe: ' + str(cantidad)
            global Cajas_Cafe
            Cajas_Cafe.set(cafe)
        case 'banano':
            banano = 'Cajas Banano: ' + str(cantidad)
            global Cajas_Banano
            Cajas_Banano.set(banano)
        case 'pina':
            pina = 'Cajas Disp.M: ' + str(cantidad)
            global Cajas_Pina
            Cajas_Pina.set(pina)
