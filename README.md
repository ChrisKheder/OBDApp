This is an app written for the 15hp course "Projekt i Elektroteknik." 1TE675 For the OBD2 project which aims to design and build an OBD2-device.
This app Features CoreBluetooth, CocoaMQTT, MapKit and CLLocation. 
The Goal of the project is to build a function OBD2-device that connects to phone which displays all the values along side a location tracker. Values should also be displayed and stored on a cloud based server.
The OBD2-device uses CAN-Bus to receive information from the car. this information is then sent through BLE using to the phone. The app then sorts the information received, displays it and sends it to a cloud based server using MQTT. 
The phone acts as the central, it searches for peripherals, connects to them and receives information through BLE. All this is done using CoreBluetooth.
CocoaMQTT is then used to uphold a connection and to send data every 20seconds to a thingspeak server
MapKit and CLLocation is used to present the devices location on a map.


BUILT WITH:

-Xcode: 14.3.1

-Swift: 5.8.1

-CoreBluetooth

-CocoaMQTT

-MapKit

-CLLocation


MINIMUM DEPLOYMENT:

-iOS: 16.4

Relevant repositories to the project:

-Arduino OBD repository: [https://github.com/GiorgiD99/OBD2-scanner-with-BLE-Vehicle-simulator ](url)

-Flask website repository: https://github.com/KevinCodeGitHub/Flask_Website 

![firstScreen](https://github.com/ChrisKheder/OBDApp/assets/117918800/f46b7b22-4ed9-4733-9768-b43bd9499efc)

![secondScreen](https://github.com/ChrisKheder/OBDApp/assets/117918800/5f21b416-192d-45eb-be95-90cc1823dbe8)

![screen](https://github.com/ChrisKheder/OBDApp/assets/117918800/1687a522-72cc-4fa4-83ab-d5119083c1d4)


