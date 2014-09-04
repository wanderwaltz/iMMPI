//
//  MockPerson.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 04.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class MockPerson {
    class func withIndex(index: Int) -> Person {
        switch (index % 3) {
        case 0: return Person(name: "Иванов Иван Иванович", gender: .Male, ageGroup: .Adult)
        case 1: return Person(name: "Сидорова Марфа Петровна", gender: .Female, ageGroup: .Adult)
            
        case 2: fallthrough
        default: return Person(name: "Петров Константин Сидорович", gender: .Male, ageGroup: .Adult)
        }
    }
}