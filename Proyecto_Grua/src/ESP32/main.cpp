#include <Arduino.h>
#include <Wire.h>

/*
Consideraciones de diseño:
Se van a enviar los pesos de los sensores de la zona de carga, a su vez se enviara
el resultado de mover las cajas (1 para funcion exitosa, 0 para error)
Se va a recibir el tipo de caja del lector QR y el visto bueno para mover la grua y
el estado del sistema para ver si el ESP debe continuar Operacion o Terminar
*/

#define LED 2
#define I2C_ADR 0x0A

//Variables del codigo
volatile uint8_t Datos_Recibidos[3] = {0, 0, 0};
volatile uint8_t Datos_Enviar[5] = {0, 0, 0, 0, 0}; //Se inicializan en 0 los datos a enviar
volatile bool received_flag = false; //En alto si se estan recibiendo datos
volatile bool update_flag = false; //En alto si los datos de los sensores se estan actualizando
volatile uint8_t Cajas_Apilado = 0; //Cajas en la zona de apilado

void Lectura(int len){
  received_flag = true;
  for (int i = 0; i < len; i++){
    Datos_Recibidos[i] = Wire.read();
  }
}

void Envio(){
  if (!update_flag) {
    Wire.write((uint8_t *)Datos_Enviar, 4);
  }
  else { //En caso de que no esten listos los datos se le manda un 6 a la raspberry pi
    Wire.write(6); //Esto porque de forma natural nunca se puede tener un 6 en el sistema
  }
}

void Leer_Peso(){ //Interrupt para actualizar los sensores de peso
  update_flag = true;
}

void Sensores_Peso(); //Medir sensores de peso

void Motor_Iman(char up_dw); //Mover motor vertical y controlar iman
/*U = Mover grua arriba, D = Mover grua abajo*/

void Mover_Grua(char tipo_caja); //Mover motor horizontal
/*B = banano, P = Piña, C = Cafe*/

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  digitalWrite(LED, LOW);
  Wire.begin(I2C_ADR);
  Wire.onReceive(Lectura);
  Wire.onRequest(Envio);

  //Set up para los registros de i2c
  #if CONFIG_IDF_TARGET_ESP32
  char message[64] = "Packets";
  Wire.slaveWrite((uint8_t *)message, strlen(message));
#endif
}


void loop() {

}


    pinLed = 0;
  }
  digitalWrite(LED, pinLed);
  sleep(1);
}
