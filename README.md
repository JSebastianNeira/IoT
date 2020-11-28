# Documentación Droser IoT
###### EQUIPO
- Juan Sebastián Neira González		A01570411
- Joel Isaí Ramos Hernández		A01245083
- Carolina Gómez Manzano		A01632229
- Luis Adrian Mendoza Rodriguez		A00829099
- Armando de Jesus Cerda De la Rosa 	A01570376

 
**Fecha:** 27/Nov/2020
 
**Materia:** Implementación de internet de las cosas

**Profesor:**
Dr. Lorena G. Gómez Martínez
Dr. Sergio Camacho


**UNIVERSIDAD:**
Instituto Tecnológico y de Estudios Superiores de Monterrey



## CAPAS 
![IOT CAPAS](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Capas.jpg?raw=true "CAPAS IOT")

###### SENSORES Y NODO (https://github.com/JSebastianNeira/IoT/tree/main/Arduino)

	Hay dos códigos 'sensores.cpp' y 'ac.cpp'. cada uno para su respectivo node.
	
	Lenguaje de programación:
   		- C++ para Arduino  
	Librerías:
    		- Arduino Json versión 5.0: Librería para poder hacer funcionar la librería de FirebaseArduino
    		- ESP8266WiFi: Librería para poder conectar el NodeMCU a la red WiFi
    		- NewPing: Librería para facilitar el uso del sensor HC-SR04
    		- DHT: Librería para usar el sensor DHT 11
		- FirebaseArduino: Librería para poder conectarse con la base de datos de Google Firebase Realtime Database
		
  	Hardware Usado:
    		- DHT11: Sensor de temperatura y humedad
    		- HC-SR04: Sensor ultrasónico
    		- Foco LED de 5mm
    		- Resistencia 220 Ω
    		- Node MCU ESP8266 V2
	IDE:
	  	- Arduino IDE
		
![hardware circuit](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Driagama%20Circuito%201.jpg?raw=true "Diagrama Circuito 1")
![hardware photo](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Node%20MCU.jpg?raw=true "Node Simulador de AC")
![hardware circuit](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Driagama%20Circuito%202.jpg?raw=true "Diagrama Circuito 2")
![hardware photo](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Hardware.jpg?raw=true "Node Sensores")


###### BASE DE DATOS
	Servidor usado:
		- Google Firebase Real Time Database, No auth in rules
		
![Firebase Photo](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Estructura%20FireBase.jpg?raw=true "Firebase Photo")
![Database Diagram](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/UML.jpg?raw=true "Database Diagram")

###### DASHBOARD (https://github.com/JSebastianNeira/IoT/tree/main/Flutter)
	Lenguaje:
		- Dart
	Framework:
		- Flutter
	Packages:
		- Cupertino.dart
		- Material.dart
		- Firebase_database.dart
		- Material_design_icons_flutter.dart
	IDE: 
    		- Android Studio
		
![Android App Screenshot](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Dashboard%201.jpg?raw=true "App screen 1")
![Android App Screenshot](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Dashboard%202.jpg?raw=true "App screen 2")
![Android App Screenshot](https://github.com/JSebastianNeira/IoT/blob/main/imagenes/Dashboard%203.jpg?raw=true "App screen 3")

## PRÓXIMAS ITERACIONES

- Prender el AC desde la App, cuidando la integridad del firebase y código del node
- Pantalla Consumo aprovechando los logs del Node en firebase
- Cálculos por usuario del consumo, authentication.

## VÍDEO

