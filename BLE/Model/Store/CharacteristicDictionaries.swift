//
//  CharacteristicDictionaries.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-11-03.
//

//-----------------Dictionaries used for sorting and categorizing max,min, Unit and names with right characteristic-----------------//
import Foundation

var characteristicName : [String: String] = [
                                            "39BB4243-7397-4CA7-82B5-DF28B670E005": "Coolant Temperature",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E012": "Engine Speed",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E013": "Vehicle Speed",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E015": "Intake Air Temperature",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E080": "Mass Air Flow",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E070": "Ambient Air Temperature",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E092": "Enginge Oil Temperature",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E099": "Engine Torque",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E047": "Fuel Tank",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E011": "Throttle position" ]

var characteristicUnit : [String: String] = [
                                            "39BB4243-7397-4CA7-82B5-DF28B670E005": "°C",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E012": "x1000",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E013": "Km/h",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E015": "ºC",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E080": "x1000g/s",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E070": "ºC",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E092": "ºC",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E099": "x10 000Nm",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E047": "%",
                                            "39BB4243-7397-4CA7-82B5-DF28B670E011": "%"]

var minValue : [String: Int] = [
                                    "39BB4243-7397-4CA7-82B5-DF28B670E005": -40,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E012": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E013": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E015": -40,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E080": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E070": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E092": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E099": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E047": 0,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E011": 0]


var maxValue : [String: Double] = [
                                    "39BB4243-7397-4CA7-82B5-DF28B670E005": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E012": 16,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E013": 255,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E015": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E080": 2.55,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E070": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E092": 210,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E099": 6.55,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E047": 100,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E011": 100]

var translator : [String: Double] = [
                                    "39BB4243-7397-4CA7-82B5-DF28B670E005": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E012": 16,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E013": 255,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E015": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E080": 2.55,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E070": 215,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E092": 210,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E099": 6.55,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E047": 100,
                                    "39BB4243-7397-4CA7-82B5-DF28B670E011": 100]


var fields : [String: String] = [
                                    "39BB4243-7397-4CA7-82B5-DF28B670E005": "field1=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E012": "field2=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E013": "field3=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E015": "field4=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E080": "field5=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E070": "field6=",
                                    "39BB4243-7397-4CA7-82B5-DF28B670E092": "field7="]
