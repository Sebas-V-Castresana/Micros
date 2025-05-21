//Terminando maquina de estados, hay que revisar que los movimientos si esten adecuados y en las direcciones correctas

//Decir a Sebastián que la RB revise si hay espacio y en base a eso decidir el estado de move

//Libraries
#include <AccelStepper.h>
#include <Wire.h>
#include "HX711.h"		// incluye libreria HX711 
#include "driver/timer.h"



// load cells
#define DT 2			// DT de HX711 a pin digital 2
#define SCK 3			// SCK de HX711 a pin digital 3

HX711 celda;			// crea objeto con nombre celda

// box kind

const int boxWidth=10; // with in steps

const int box1=20;
const int box2=40;
const int box3=60;


const int pos[5]={boxWidth*5,boxWidth*4, boxWidth*3, boxWidth*2,boxWidth};
// const int pos1=boxWidth*4;
// const int pos2=boxWidth*3; 
// const int pos3=boxWidth*2;
// const int pos4=boxWidth;



// timers

hw_timer_t *timer = NULL;
volatile bool readLC = false;

// communication

// #define LED 2
// #define I2C_ADR 0x0A
// #define SDA_PIN 21
// #define SCL_PIN 22

// // Variables de la comunicación

// volatile uint8_t Datos_Recibidos[3] = {0, 0, 0}; // run, kind, vSZ
// volatile uint8_t Datos_Enviar[5] = {0, 0, 0, 0, 0}; //Se inicializan en 0 los datos a enviar






// interrupt pins

// const int lSwU=2; //limit switch up
// const int lSwL=3; //limit switch left

// movement variables
volatile bool move = false;
volatile bool read = false;

// vertical motor configuration

const int vMPin1 = 1;
const int vMPin2 = 2;
const int vMPin3 = 3;
const int vMPin4 = 4;

// horizontal motor configuration

const int hMPin1 = 5;
const int hMPin2 = 6;
const int hMPin3 = 7;
const int hMPin4 = 8;

// vertical and horizontal motor
AccelStepper vM(AccelStepper::HALFSTEP, vMPin1, vMPin2, vMPin3, vMPin4);
AccelStepper hM(AccelStepper::HALFSTEP, hMPin1, hMPin2, hMPin3, hMPin4);

// fsm

enum estados{
	sZD,
	sZU,
	movR,
	movD,
	movU,
	movL,
	};

estados current = setup;

// position

const int og=20;

// limit switch variables
// volatile bool upPosition=false;
// volatile bool leftPosition=false;
// volatile bool stackPosition=false;

bool downPosition=false;
bool rightPostion=false;




void setup(){

	// load cells task
	 xTaskCreatePinnedToCore(
    measure,          // Función de la tarea
    "load cells measurements",        // Nombre de la tarea
    10000,            // Tamaño del stack (bytes)
    NULL,             // Parámetro de la tarea
    1,                // Prioridad (0 a configMAX_PRIORITIES-1)
    NULL,             // Handle de la tarea
    0                 // Núcleo (0 o 1)
  );

	// timer setup

	// Initialize timer (timer 0, divider 80, count up)
  timer = timerBegin(0, 80, true);
  
  // Attach interrupt to timer
  timerAttachInterrupt(timer, &onTimer, true);
  
  // Set alarm value (1 second)
  timerAlarmWrite(timer, 200000, true);
  
  // Enable alarm
  timerAlarmEnable(timer);


	// vertical motor
	vM.setMaxSpeed(1000);
	vM.setAcceleration(500);
	vM.moveTo(0);
	vM.setCurrentPosition(0);

	// horizontal motor
	hM.setMaxSpeed(1000);
	hM.setAcceleration(500);
	hM.moveTo(0);
	hM.setCurrentPosition(0);

	// limit switch interrupts
	pinMode(lSwL, INPUT);
	pinMode(lSwU, INPUT);

	// attachInterrupt(digitalPinToInterrupt(lSwL), leftSwitch, RISING);
	// attachInterrupt(digitalPinToInterrupt(lSwU), upSwitch, RISING);


	// load cells
	celda.begin(DT, SCK);		// inicializa objeto con los pines a utilizar

  celda.set_scale(-764.86);	// establece el factor de escala obtenido del primer programa
  celda.tare();
	celda.power_up();
}

// functions

// interrupts

// // horizontal interrupt, sets new horizontal position reference
// void leftSwitch(){
// 	hM.setCurrentPosition(0);
// 	leftPosition=true;
// }

// // vertical interrupt, sets new vertical position reference
// void upSwitch(){
// 	vM.setCurrentPosition(0);
// 	upPosition=true;
// }

// timer flag ISR
void IRAM_ATTR onTimer() {
  readLC = true;
}


void measure(void * pvParameters) {
  while(1) {
    if (readLC){

			readLC=false;

			lCData[0]=celda.get_units(5);	// muestra el valor obtenido promedio de 10 lecturas

			for (int i = 0; i < 5; i++){
				if (lCData[i]<=30){
					Datos_Enviar[i]=0
				}
				else if (lCData[i]<=60 && lCData[i] > 30){
					Datos_Enviar[i]=1
				}
				else if (lCData[i]<=90 && lCData[i] > 60){
					Datos_Enviar[i]=2
				}
				else if (lCData[i]<=120 && lCData[i] > 90){
					Datos_Enviar[i]=3
				}
				else if (lCData[i]<=150 && lCData[i] > 120){
					Datos_Enviar[i]=4
				} else {
					Datos_Enviar[i]=5
				}
			}
  	}

		vTaskDelay(1);  // Yield to other tasks (minimal delay)
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

    // Assign sZDisplacement based on index 2 (pos0 to pos4)
    if (Datos_Recibidos[2] == 0) {
        sZDisplacement = posä[0];
    }
    else if (Datos_Recibidos[2] == 1) {
        sZDisplacement = pos[1];
    }
    else if (Datos_Recibidos[2] == 2) {
        sZDisplacement = pos[2];
    }
    else if (Datos_Recibidos[2] == 3) {
        sZDisplacement = pos[3];
    }
    else if (Datos_Recibidos[2] == 4) {
        sZDisplacement = pos4;
    }
}

void loop(){
	switch(current){

		case setup:
		
				if (move){
					displacementSelect();
					movement=sZDisplacement;
					current=sZMovD;
				}
				
				break;

		case sZMovD:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition()):
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				digitalWrite(eM, 1); //activate electromagnet
				movement=-sZDisplacement;
				current=sZMovU;
				delay();
			}

			break;

		case sZMovU:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition()):
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
				vM.moveTo(vM.currentPosition()):
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
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition()):
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				
				digitalWrite(eM, 0); //deactivate electromagnet
				movement=-vDisplacement;
				current=movU;
			}

			break;
			
		case movU:

			if(move){
				hM.moveTo(hM.currentPosition());
				vM.moveTo(movement);
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition()):
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				movement=-hDisplacement;
				current=movL;
			}

			break;

		case movL:

			if(move){
				hM.moveTo(movement);
				vM.moveTo(vM.currentPosition());
			} else {
				hM.moveTo(hM.currentPosition());
				vM.moveTo(vM.currentPosition()):
			}

			if(move && vM.distanceToGo()==0 && hM.distanceToGo()==0){
				movement=0;
				current=setup;
			}

			break;

	


	}

	vM.run();
	hM.run();

}



