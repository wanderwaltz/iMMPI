//
//  JSONQuestionnaireFactory.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class JSONQuestionnaireFactorySpec: QuickSpec {
    override func spec() {
        describe("JSONQuestionnaireFactory") {
            context("when newly created") {
                var factory: JSONQuestionnaireFactory!
                beforeEach {
                    factory = JSONQuestionnaireFactory()
                }
                
                it("should return a non-nil Questionnaire for Adult Male group") {
                    expect(factory.questionnaire(gender: .Male, ageGroup: .Adult)).notTo(beNil())
                }
                
                it("should return a non-nil Questionnaire for Teen Male group") {
                    expect(factory.questionnaire(gender: .Male, ageGroup: .Teen)).notTo(beNil())
                }
                
                it("should return a non-nil Questionnaire for Adult Female group") {
                    expect(factory.questionnaire(gender: .Female, ageGroup: .Adult)).notTo(beNil())
                }
                
                it("should return a non-nil Questionnaire for Teen Female group") {
                    expect(factory.questionnaire(gender: .Female, ageGroup: .Teen)).notTo(beNil())
                }
            }
        }
    }
}