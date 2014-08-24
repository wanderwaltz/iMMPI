//
//  AgeGroup.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation


enum AgeGroup : String {
    case Unknown = "unknown"
    case Teen = "teen"
    case Adult = "adult"
    
    static func fromString(string: String) -> AgeGroup {
        switch string {
        case "adult":
            return .Adult
        case "teen":
            return .Teen
        default:
            return .Unknown
        }
    }
}