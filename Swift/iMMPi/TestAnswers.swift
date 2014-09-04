//
//  TestAnswers.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 04.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

protocol TestAnswers {
    var allAnswered : Bool { get }
    
    func setAnswer(answer: AnswerType, forStatementID: Int)
    func answerForStatement(#ID: Int) -> AnswerType
}