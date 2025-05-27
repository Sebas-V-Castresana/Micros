//Terminando maquina de estados, hay que revisar que los movimientos si esten adecuados y en las direcciones correctas

//Decir a Sebastián que la RB revise si hay espacio y en base a eso decidir el estado de move

//Revisar si el timer se vuelve a activar antes que todas las lecturas de las celdas de carga

//Libraries
#include <AccelStepper.h>
#include <Wire.h>
#include "HX711.h"		// incluye libreria HX711 
#include "esp32-hal-timer.h"



// load cells

float lCData[4]={0};

#define DT0 1			// DT de HX711 a pin digital 2
#define SCK0 2			// SCK de HX711 a pin digital 3
// load cells
#define DT1 23			// DT de HX711 a pin digital 2
#define SCK1 25			// SCK de HX711 a pin digital 3
// load cells
#define DT2 26			// DT de HX711 a pin digital 2
#define SCK2 27			// SCK de HX711 a pin digital 3
// load cells
#define DT3 32			// DT de HX711 a pin digital 2
#define SCK3 33			// SCK de HX711 a pin digital 3

HX711 celda0;			// crea objeto con nombre celda
HX711 celda1;
HX711 celda2;			// crea objeto con nombre celda
HX711 celda3;


// boxes

const int boxWidth=50; // width in steps

// horizontal positions

const int box1=500;
const int box2=1000;
const int box3=1500;

// vertical displacements

const int pos[5]={boxWidth*5,boxWidth*4, boxWidth*3, boxWidth*2,boxWidth};

// timers

hw_timer_t *timer = NULL;

portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;

volatile bool readLC = false;


// communication

#define I2C_ADR 0x0A
#define SDA_PIN 3
#define SCL_PIN 4

// Variables de la comunicación

volatile uint8_t Datos_Recibidos[2] = {0, 0}; // run, kind
volatile uint8_t Datos_Enviar[5] = {0, 0, 0, 0, 0}; // box quantity and in progress byte

// interrupt pins

// const int lSwU=2; //limit switch up
// const int lSwL=3; //limit switch left

// movement variables
volatile bool move = false;
volatile bool inProgress = false;

int hDisplacement = 0;
int vDisplacement = 0;
int sZDisplacement = 0;
int movement = 0;

// vertical motor configuration

const int vMPin1 = 1;
const int vMPin2 = 2;


// horizontal motor configuration

const int hMPin1 = 5;
const int hMPin2 = 6;

// electromagnet

const int eM=25;

// vertical and horizontal motor
AccelStepper vM(1,22,21);
AccelStepper hM(1,16,17);

// fsm

enum estados{
	sZSetup,
	sZMovD,
	sZMovU,
	movR,
	movD,
	movU,
	movL,
	};

estados current = sZSetup;

// position
bool downPosition=false;
bool rightPostion=false;

// timer functions

// timer flags
void IRAM_ATTR onTimer() {
  readLC = true;
}

void setup(){

	Serial.begin(9600);

	// i2c slave task
	xTaskCreatePinnedToCore(
    i2C,     // Función de la tarea
    "I2C Slave Task", // Nombre
    4096,             // Stack size
    NULL,             // Parámetro
    1,                // Prioridad
    NULL,             // Handle
    0                 // Core 0
  );

	// load cells task
	 xTaskCreatePinnedToCore(
    measure,          // Función de la tarea
    "load cells measurements",        // Nombre de la tarea
    10000,            // Tamaño del stack (bytes)
    NULL,             // Parámetro de la tarea
    1,                // Prioridad (0 a configMAX_PRIORITIES-1)
    NULL,             // Handle de la tarea
    1                 // Núcleo (0 o 1)
  );

	// electromagnet
	pinMode(eM, OUTPUT);
	digitalWrite(eM, 0);

	// timer setup

	// Initialize timer (timer 0, divider 80, count up)
  timer = timerBegin(0, 80, true);
  
  // Attach interrupt to timer
  timerAttachInterrupt(timer, &onTimer, true);
  
  // Set alarm value (1 second)
  timerAlarmWrite(timer, 1000000, true);
  
  // Enable alarm
  timerAlarmEnable(timer);


	// vertical motor
	vM.setMaxSpeed(100);
	vM.setAcceleration(50);
	vM.setCurrentPosition(0);
	vM.moveTo(0);
	
	

	// horizontal motor
	hM.setMaxSpeed(100);
	hM.setAcceleration(50);
	hM.setCurrentPosition(0);
	hM.moveTo(0);
	
	
	// load cells
	celda0.begin(DT0, SCK0);		// inicializa objeto con los pines a utilizar
  celda0.set_scale(-712.3176);	// establece el factor de escala obtenido del primer programa
  celda0.tare();
	celda0.power_up();

	celda1.begin(DT1, SCK1);		// inicializa objeto con los pines a utilizar
  celda1.set_scale(-712.3176);	// establece el factor de escala obtenido del primer programa
  celda1.tare();
	celda1.power_up();

	celda2.begin(DT2, SCK2);		// inicializa objeto con los pines a utilizar
  celda2.set_scale(-712.3176);	// establece el factor de escala obtenido del primer programa
  celda2.tare();
	celda2.power_up();

	celda3.begin(DT3, SCK3);		// inicializa objeto con los pines a utilizar
  celda3.set_scale(-712.3176);	// establece el factor de escala obtenido del primer programa
  celda3.tare();
	celda3.power_up();
}

void retardo() {
  unsigned long start = millis();
  // Espera hasta que hayan pasado 150 ms
  while (millis() - start < 150) {
    // no hacer nada, solo esperar
		vM.run();
		hM.run();
  }
}

// communication functions
void i2C(void * parameter) {
  while (true) {
    if (Serial.available()) {
      int run = Serial.parseInt();
      int kind = Serial.parseInt();

      if (run >= 0 && run <= 255 && kind >= 0 && kind <= 255) {
        Datos_Recibidos[0] = (uint8_t)run;
        Datos_Recibidos[1] = (uint8_t)kind;

        // Serial.print("Actualizado: RUN = ");
				move=(uint8_t)run;
        // Serial.print(Datos_Recibidos[0]);
        // Serial.print(", KIND = ");
        // Serial.println(Datos_Recibidos[1]);
      } else {
        // Serial.println("Valores fuera de rango (0-255)");
      }

      // Limpiar el buffer
      while (Serial.available()) Serial.read();
    }
    vTaskDelay(10 / portTICK_PERIOD_MS); // pequeña espera
  }
}

void Lectura(int len){
  for (int i = 0; i < len; i++){
    Datos_Recibidos[i] = Wire.read();
  }
	move=Datos_Recibidos[0];
}

void Envio(){
	Datos_Enviar[4] = inProgress;
  Wire.write((uint8_t *)Datos_Enviar, 5);
}





void measure(void * pvParameters) {
  while(1) {
    if (readLC){

			readLC=false;

			lCData[0]=celda0.get_units(5);	// muestra el valor obtenido promedio de 10 lecturas
			lCData[1]=celda1.get_units(5);
			lCData[2]=celda2.get_units(5);
			lCData[3]=celda3.get_units(5);

			//Serial.println(lCData[0]);
			
	

			for (int i = 0; i < 1; i++){
				if (lCData[i]<=30){
					Datos_Enviar[i]=0;
					//Serial.println("0 cajas");
				}
				else if (lCData[i]<=60 && lCData[i] > 30){
					Datos_Enviar[i]=1;
					// Serial.println("1 cajas");
				}
				else if (lCData[i]<=90 && lCData[i] > 60){
					Datos_Enviar[i]=2;
					// Serial.println("2 cajas");
				}
				else if (lCData[i]<=120 && lCData[i] > 90){
					Datos_Enviar[i]=3;
					// Serial.println("3 cajas");
				}
				else if (lCData[i]<=150 && lCData[i] > 120){
					Datos_Enviar[i]=4;
					// Serial.println("4 cajas");
				} else {
					Datos_Enviar[i]=5;
					// Serial.println("5 cajas");
				}
			}
  	}

		vTaskDelay(10 / portTICK_PERIOD_MS);  // Yield to other tasks (minimal delay)
	}
}


void displacementSelect() {
    // Assign hDisplacement based on index 1 (box1 to box3)
    if (Datos_Recibidos[1] == 1) {
        hDisplacement = box1;
				vDisplacement = pos[Datos_Enviar[1]];
    } 
    else if (Datos_Recibidos[1] == 2) {  // Fixed: Changed from ==0 to ==1
        hDisplacement = box2;
				vDisplacement = pos[Datos_Enviar[2]];
    }
    else if (Datos_Recibidos[1] == 3) {
        hDisplacement = box3;
				vDisplacement = pos[Datos_Enviar[3]];
    }

    // Assign sZDisplacement based on index 2 (pos0 to pos4)//MODIFICAR PARA UTILIZAR DATOS PROPIOS	
    if (Datos_Enviar[0] == 0) {
        sZDisplacement = pos[0];
    }
    else if (Datos_Enviar[0] == 1) {
        sZDisplacement = pos[1];
    }
    else if (Datos_Enviar[0] == 2) {
        sZDisplacement = pos[2];
    }
    else if (Datos_Enviar[0] == 3) {
        sZDisplacement = pos[3];
    }
    else if (Datos_Enviar[0] == 4) {
        sZDisplacement = pos[4];
    }
}

void loop(){
	switch(current){

		case sZSetup:
			
				if (move){
				
					displacementSelect();
					movement=sZDisplacement;
					inProgress = 1;
					current=sZMovD;
				}
				
				break;

		case sZMovD:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
				
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				retardo();
				digitalWrite(eM, 1); //activate electromagnet
				retardo();

				movement=-1*sZDisplacement;
				current=sZMovU;
				
			}

			break;

		case sZMovU:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
				
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				movement=hDisplacement;
				current=movR;
			}

			break;

		case movR:

			if(move){
				hM.moveTo(movement);
				vM.moveTo(vM.currentPosition());
				
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				movement=vDisplacement;
				current=movD;
			}

			break;

	
		case movD:


			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
				// Serial.println("movD");
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				retardo();
				digitalWrite(eM, 0); //deactivate electromagnet
				retardo();

				movement=-1*vDisplacement;
				current=movU;
			}

			break;
			
		case movU:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
				// Serial.println("movU");
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				movement=-1*hDisplacement;
				current=movL;
			}

			break;

		case movL:

			if(move){
				hM.moveTo(movement);
				vM.moveTo(vM.currentPosition());
				// Serial.println("movL");
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				// Serial.println("quieto");
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition());
				inProgress = 0;
				retardo();
				current=sZSetup;
			}

			break;

	


	}

	vM.run();
	hM.run();

}



