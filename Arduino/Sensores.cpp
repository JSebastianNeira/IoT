#include <ESP8266WiFi.h>    //Placa ESP8266
#include <NewPing.h>  //Facilita sensor ultrasonico 
#include "DHT.h"      //Sensor DHT11 (Humedad y Temperatura) 
#include <FirebaseArduino.h> //Firebase

// Credenciales Firebase
#define FIREBASE_HOST "yourProjectName.firebaseio.com" 
#define FIREBASE_AUTH "yourAuthenticationCode"

//Credenciales WiFi Local
#define WIFI_SSID "YOUR-SSID-NAME" 
#define WIFI_PASSWORD "SSID-Password"

//Pins y constante del Sensor Ultrasonico
#define TRIGGER 0 //Pin D3
#define ECHO 4    //Pin D2
#define MAX_LENGHT 40 

//Pins Sensor de Humedad y Temperatura
#define DHTPIN 2 //Pin D4
#define DHTTYPE DHT11

//Usuario
const String USUARIO = "UserName/UserCode"; //Nombre o clave del usuario

NewPing ultrasonic(TRIGGER, ECHO, MAX_LENGHT); //(trigger, echo, max distance)
DHT dht(DHTPIN, DHTTYPE); //(pin, sensor type)

void setup(){
  Serial.begin(9600);
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD); //Concect to local by WiFi
  Serial.print("Connecting");
  Serial.print(WIFI_SSID);

  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.print("Connected to ");
  Serial.print(WIFI_SSID);
  Serial.print(" - ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); //Connect to firebase
  
  dht.begin();

}

int DistTemp[3] = {0,0,0};
int Distance = 0, Position = 0, Iterator = 0, iFail = 0, Errors = 0;
float Temperature = 0, Humidity = 0, HeatIndex, TemperatureApp;
bool Fail = false, inout = false, door = false;
int distanceLimit = 15;
DynamicJsonBuffer jsonBuffer;


void loop(){
  //Repetir 60 veces, 1 segundo por ciclo
  for(int i=0; i<60; i++){
    //Leer Distancia del sensor ultrasonico en cm
    DistTemp[Position] = ultrasonic.ping_cm();
    
    //Si todas las distancias pasadas son iguales, Dist es DistTemp  
    if(DistTemp[0] == DistTemp[1] && DistTemp[1] == DistTemp[2]){
      Distance = DistTemp[Position];
    }
    
    JsonObject& registerObject = jsonBuffer.createObject();
    JsonObject& tempTime1 = registerObject.createNestedObject("Fecha&Hora");
   
    Firebase.setFloat(USUARIO + "/Distancia", Distance);
    //En este if habra que investigar si la perona entro o salio
    if((Distance >= distanceLimit) && !door){ //Depende el setup puede ser <= o >=
      inout = !inout; //entro/salio
      door = true; //La puerta se encuentra abierta

      registerObject["EntradaSalida"] = inout;
      tempTime1[".sv"] = "timestamp";
      Firebase.push(USUARIO + "/RegisterLogs", registerObject);
    
      Firebase.setBool(USUARIO + "/EntradaSalida", inout);
      Firebase.setBool(USUARIO + "/Door", door);
    }

    if(Distance < distanceLimit){
      door = false; //La puerta se encuentra cerrada
      Firebase.setBool(USUARIO + "/Door", door);
    }

    //Rotar la posicion del arreglo
    if(Position >= 2){
      Position = 0;
    }else{
      Position++;
    }

    delay(1000);
  }

  //Mientras no lea valores adecuados (Max 5 segundos) 
  Temperature = dht.readTemperature();
  Humidity = dht.readHumidity();
  Fail = false;
  delay(1000);
  while((isnan(Temperature) || isnan(Humidity)) && Iterator < 4){
    Temperature = dht.readTemperature();
    Humidity = dht.readHumidity(); 
    delay(1000);
    Iterator++;
    Fail = (Iterator == 4);
  }
  Iterator = 0;
  //Si no hubo mas de 5 fallas
  if(!Fail){
    iFail = 0; //FallasSeguidas es cero

    //Calcular Indice de Calor
    HeatIndex = dht.computeHeatIndex(Temperature, Humidity, false);

    //Mandar valores a base de datos
    JsonObject& temperatureObject = jsonBuffer.createObject();
    JsonObject& tempTime2 = temperatureObject.createNestedObject("Fecha&Hora");
    
    temperatureObject["Temperature"] = Temperature;
    temperatureObject["Humidity"] = Humidity;
    temperatureObject["HeatIndex"] = HeatIndex;
    tempTime2[".sv"] = "timestamp";
    
    Firebase.push(USUARIO + "/TemperatureLogs", temperatureObject);
    Firebase.setFloat(USUARIO + "/HeatIndex", HeatIndex);
    Firebase.setFloat(USUARIO + "/Humidity", Humidity);
    
  }else{
    iFail++; //Aumentar Num de errores seguidos
    Errors++; //Aumentar Num de errores totales
    Serial.println(iFail);
    Serial.println(Errors);
  }

}