#include <AccelStepper.h>

// interrupt pins
const int lSwU=2; //limit switch up
const int lSwL=3; //limit switch left

// movement variables
volatile bool move = false;

// vertical motor configuration

const int vMPin1 = 1;
const int vMPin2 = 2;
const int vMPin3 = 3;
const int vMPin4 = 4;

// horizontal motor configuration

const int hMPin1 = 5;
const int hMPin2 = 6;
const int hMPin3 = 7;
const int hMpin4 = 8;

// vertical and horizontal motor
AccelStepper vM(AccelStepper::HALFSTEP, vMPin1, vMPin2, vMPin3, vMPin4);
AccelStepper hM(AccelStepper::HALFSTEP, hMPin1, hMPin2, hMPin3, hMpin4);

// fsm

enum estados{
	setup,
	stackZone,
	movU,
	movD,
	movR,
	movL,
	};

estados current = setup;

// position

const int og=20;

// limit switch variables
volatile bool up=false;
volatile bool left=false;


void setup(){

	// vertical motor
	vM.setMaxSpeed(1000);
	vM.setAcceleration(500);
	vM.moveTo(2000);

	// horizontal motor
	hM.setMaxSpeed(1000);
	hM.setAcceleration(500);
	hM.moveTo(2000);

	// limit switch interrupts
	pinMode(lSwL, INPUT);
	pinMode(lSwU, INPUT);

	attachInterrupt(digitalPinToInterrupt(lSwL), leftSwitch, RISING);
	attachInterrupt(digitalPinToInterrupt(lSwU), upSwitch, RISING);
}


void loop(){
	switch(current){
		case setup:
			//include code to verify i2c


			if(move && !lSwL && !lSwU){


			} else if(move && !lSwL && lSwU){

			} else if(move && lSwL && lSwU){
				if(!mS.moveTo(og)){
					//Enviar comunicacion de que esta en el origen
				}
			}

			break;

	}





}


// horizontal interrupt, sets new horizontal position reference
void leftSwitch(){
	move=true;
}

// vertical interrupt, sets new vertical position reference
void upSwitch(){
	move=false;
}