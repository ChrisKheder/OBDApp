//
//  Mock.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-19.
//

import Foundation

protocol Mock {}

extension Mock{
    var className: String{
        return String(describing: type(of: self))
    }
    
    func log(_ message: String? = nil){
        print("Mocked -", className, message ?? "")
    }
}
