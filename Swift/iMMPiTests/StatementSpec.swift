//
//  StatementSpec.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class StatementSpec: QuickSpec {
    override func spec() {
        describe("Statement") {
            context("when comparet to another statement") {
                let statement = Statement(ID: 123, text: "text")
                let sameStatement = Statement(ID: 123, text: "text")
                let differentID = Statement(ID: 456, text: "text")
                let differentText = Statement(ID: 123, text: "different text")
                
                it("should be equal to the Statement with the same ID and text") {
                    expect(statement).to(equal(sameStatement))
                }
                
                it("should be distinct from Statement with different ID") {
                    expect(statement).notTo(equal(differentID))
                }
                
                it("should be distinct from Statement with different text") {
                    expect(statement).notTo(equal(differentText))
                }
            }
        }
    }
}