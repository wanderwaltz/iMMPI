//
//  Gender.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation


enum Gender : String {
    case Unknown = "unknown"
    case Male = "male"
    case Female = "female"
    
    static func fromString(string: String) -> Gender {
        switch string {
        case "male":
            return .Male
        case "female":
            return .Female
        default:
            return .Unknown
        }
    }
}