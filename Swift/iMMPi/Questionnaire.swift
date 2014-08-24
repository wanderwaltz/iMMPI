//
//  Questionnaire.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

protocol Questionnaire {
    var statementsCount: Int { get }
    
    func statement(atIndex index: Int) -> Statement
    func statement(#ID: Int) -> Statement?
}