This is an app written for the 15hp course "Projekt i Elektroteknik." For the OBD2 project which aims to design and build an OBD2-device.
This app Features CoreBluetooth, CocoaMQTT, MapKit and CLLocation. 
The Goal of the project is to build a function OBD2-device that connects to phone which displays all the values along side a location tracker. Values should also be displayed and stored on a cloud based server.
The OBD2-device uses CAN-Bus to receive information from the car. this information is then sent through BLE using to the phone. The app then sorts the information received, displays it and sends it to a cloud based server using MQTT. 
The phone acts as the central, it searches for peripherals, connects to them and receives information through BLE. All this is done using CoreBluetooth.
CocoaMQTT is then used to uphold a connection and to send data ecery 20seconds to a thingspeak server
MapKit and CLLocation is used to present the devices location on a map.


