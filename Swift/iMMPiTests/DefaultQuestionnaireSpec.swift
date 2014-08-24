//
//  DefaultQuestionnaireSpec.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class DefaultQuestionnaireSpec: QuickSpec {
    override func spec() {
        describe("DefaultQuestionnaire") {
            context("when created with a list of Statements") {
                let statement1 = Statement(ID: 123, text: "text of statement 1")
                let statement2 = Statement(ID: 456, text: "text of statement 2")
                let questionnaire = DefaultQuestionnaire(statements: [statement1, statement2])
                
                it("should properly indicate the number of statements included") {
                    expect(questionnaire.statementsCount).to(equal(2))
                }
                
                it("should return proper statements for given indexes") {
                    expect(questionnaire.statement(atIndex: 0)).to(equal(statement1))
                    expect(questionnaire.statement(atIndex: 1)).to(equal(statement2))
                }
                
                it("should return proper statements for given statement IDs") {
                    expect(questionnaire.statement(ID: 123)).to(equal(statement1))
                    expect(questionnaire.statement(ID: 456)).to(equal(statement2))
                }
            }
        }
    }
}