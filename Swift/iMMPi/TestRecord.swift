//
//  TestRecord.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 04.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

protocol TestRecord {
    var person : Person { get }
    var answers : TestAnswers { get }
    var date : NSDate { get }
}