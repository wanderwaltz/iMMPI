//
//  MockTestAnswers.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 04.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class MockTestAnswers : TestAnswers {
    let allAnswered : Bool = true
    
    func setAnswer(answer: AnswerType, forStatementID: Int) {
        
    }
    
    func answerForStatement(#ID: Int) -> AnswerType {
        switch (ID % 2 + 1) {
        case AnswerType.Positive.toRaw(): return .Positive
        case AnswerType.Negative.toRaw(): return .Negative
        default: return .Unknown
        }
    }
}