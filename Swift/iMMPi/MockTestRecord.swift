//
//  MockTestRecord.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 04.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class MockTestRecord : TestRecord {
    let person : Person
    let answers : TestAnswers
    let date : NSDate
    
    init(index: Int) {
        date = NSDate()
        person = MockPerson.withIndex(index)
        answers = MockTestAnswers()
    }
}