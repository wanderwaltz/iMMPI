//
//  JSONQuestionnaire.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class DefaultQuestionnaire : Questionnaire {
    let statementsCount: Int
    
    init(statements: [Statement]) {
        self.statementsCount = statements.count
        self.statements = statements
        
        var byID: [Int : Statement] = [:];
        
        for statement in statements {
            byID[statement.ID] = statement
        }
        
        self.statementsByID = byID
    }
    
    func statement(#ID: Int) -> Statement? {
        return statementsByID[ID]
    }
    
    func statement(atIndex index: Int) -> Statement {
        return statements[index]
    }
    
    private let statements: [Statement]
    private let statementsByID: [Int : Statement]
}