//
//  MQTT.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-12-02.
//

import Foundation
import CocoaMQTT

class IoTManager : CocoaMQTTDelegate{
    
    
    //--------Buffer variables--------//
    private var messageQueue: String = ""
    private var timer: Timer?
    
    
    var mqtt: CocoaMQTT!
        
    func connectToIoTDevice(){
        let ID = "MAAUJD01KCYYKyELOwQ5KSk"
        let serverURL = "mqtt3.thingspeak.com"
        let serverPort: UInt16 = 1883

        mqtt = CocoaMQTT(clientID: ID, host: serverURL, port: serverPort)
        mqtt.username = "MAAUJD01KCYYKyELOwQ5KSk"
        mqtt.password = "3pyIegQUbqr8HvItHI9eh20b"
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.connect()
    }
    
    //------------------------------Protocol functions------------------------------//
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            print("Disconnected from IoT Device with error \(error.localizedDescription)")
        } else{
            print("Disconnected from IoT Device")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("unsubscribed to topic: \(topics)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
                    print("Connected to the IoT device!")
                    // Perform actions after successful connection
                } else {
                    print("Failed to connect to the IoT device")
                }
            }
    
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16 ){
        print("Message published successfully")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let messageString = message.string {
                    print("Received message on topic \(message.topic): \(messageString)")
                    // Process the received message
                }
    }
}

    //------------------------------Extenstion------------------------------//

extension IoTManager{
    func subscribeToTopic(topic: String){
        mqtt.subscribe(topic)
    }
    
    func publishData(topic: String, message:  String){
        mqtt.publish(topic, withString: message, qos: .qos1)
    }
    
    //---------------------------buffer functions---------------------------//
    
    // Add a message to the buffer
    func addMessage(_ message: String) {
        if messageQueue == ""{
            messageQueue = message
        }else{
            messageQueue = messageQueue + "&" + message
        }
    }

    // Start the timer to periodically send messages
    func startSending() {
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(sendMessages), userInfo: nil, repeats: true)
    }

    // Stop the timer
    func stopSending() {
        timer?.invalidate()
        timer = nil
    }
    
    func containing(field: String) -> Bool{
        return messageQueue.contains(field)
    }

    // Timer selector to send messages
    @objc private func sendMessages() {
        guard !messageQueue.isEmpty else {
            return
        }

        //Sending the whole string.
        publishData(topic: "channels/2351521/publish", message: messageQueue)
        print("Sending message: \(messageQueue)")
        messageQueue = ""
    }
}
