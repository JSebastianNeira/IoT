//Librerias
#include <ESP8266WiFi.h>    //Placa ESP8266 
#include <FirebaseArduino.h> //Firebase

// Credenciales Firebase
#define FIREBASE_HOST "yourProjectName.firebaseio.com" 
#define FIREBASE_AUTH "yourAuthenticationCode"

//Credenciales WiFi Local
#define WIFI_SSID "" 
#define WIFI_PASSWORD ""

//PIN FAN
#define FAN 4 //D2

//Usuario
const String USUARIO = ""; //Nombre o clave del usuario

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

  pinMode(FAN, OUTPUT);

}

bool EntSal;
String Velocity;
float TemperatureApp;
float HeatIndex;
bool cambioMenor = false;
bool cambioMayor = false;
bool primeraVez = true;
DynamicJsonBuffer jsonBuffer;

void loop(){
  //Recibir la Temperatura que el usario desea de la base de datos
  TemperatureApp = Firebase.getFloat(USUARIO + "/TemperaturaApp");
  if (Firebase.failed()){ 
    Serial.print("setting /number failed:"); 
    Serial.println(Firebase.error());   
    return; 
  }

  HeatIndex = Firebase.getFloat(USUARIO + "/HeatIndex");
  if (Firebase.failed()){ 
    Serial.print("setting /number failed:"); 
    Serial.println(Firebase.error());   
    return; 
  }

  EntSal = Firebase.getBool(USUARIO + "/EntradaSalida");
  if (Firebase.failed()){ 
    Serial.print("setting /number failed:"); 
    Serial.println(Firebase.error());   
    return;
  }

  JsonObject& ACObject = jsonBuffer.createObject();
  JsonObject& tempTime = ACObject.createNestedObject("Fecha&Hora");

  //Dependiendo de como este la Temperatura, que velocidad usar
  //HIGH -> Encendido Fuerte
  //LOW -> Apagado
  if(EntSal){
    primeraVez = true;
    if(HeatIndex > TemperatureApp && !cambioMayor){
      ACObject["OnOff"] = true;
      tempTime[".sv"] = "timestamp";
      Firebase.push(USUARIO + "/ACLogs", ACObject);
      Firebase.setBool(USUARIO + "/ACStatus", true);

      if (Firebase.failed()){ 
        Serial.print("setting /number failed:"); 
        Serial.println(Firebase.error());   
        return; 
      }
      digitalWrite(FAN, HIGH); 
      cambioMayor = true;
      cambioMenor = false;
    }
    
    if(HeatIndex <= TemperatureApp && !cambioMenor){
      ACObject["OnOff"] = false;
      tempTime[".sv"] = "timestamp";
      Firebase.push(USUARIO + "/ACLogs", ACObject);
      Firebase.setBool(USUARIO + "/ACStatus", false);

      if (Firebase.failed()){ 
        Serial.print("setting /number failed:"); 
        Serial.println(Firebase.error());   
        return; 
      }
      digitalWrite(FAN, LOW);
      cambioMenor = true;
      cambioMayor = false;
    }
  } else{
    if(primeraVez){
      ACObject["OnOff"] = false;
      tempTime[".sv"] = "timestamp";
      Firebase.push(USUARIO + "/ACLogs", ACObject);
      Firebase.setBool(USUARIO + "/ACStatus", false);

      if (Firebase.failed()){ 
        Serial.print("setting /number failed:"); 
        Serial.println(Firebase.error());   
        return; 
      }
      digitalWrite(FAN, LOW);
      primeraVez = false;
    }
    
    cambioMayor = false;
    cambioMenor = false;
  }

  delay(2000);
}