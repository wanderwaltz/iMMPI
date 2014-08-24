//
//  JSONStatementFactorySpec.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class JSONStatementFactorySpec: QuickSpec {
    override func spec() {
        describe("JSONStatementFactory") {
            var factory: JSONStatementFactory!
            beforeEach {
                factory = JSONStatementFactory()
            }
            
            context("when trying to create Statement from a valid JSON") {
                let ID = 123
                let text = "text"
                var json : JSONValue!
                beforeEach {
                    json = JSONValue(["id" : 123, "text" : text])
                }
                
                it("should a non-nil Statement object") {
                    expect(factory.statement(fromJSON: json)).notTo(beNil())
                }
                
                it("should set the Statement properties to values read from the JSON") {
                    let statement = factory.statement(fromJSON: json)!
                    expect(statement.ID).to(equal(ID))
                    expect(statement.text).to(equal(text))
                }
            }
            
            
            context("when trying to create Statement from invalid JSON") {
                it("should return nil for null JSON objects") {
                    expect(factory.statement(fromJSON: JSONValue.JNull)).to(beNil())
                }
                
                it("should return nil for JSON objects without 'id'") {
                    let json = JSONValue.JObject(["text" : JSONValue("some text")])
                    expect(factory.statement(fromJSON: json)).to(beNil())
                }
                
                it("should return nil for JSON objects without 'text'") {
                    let json = JSONValue.JObject(["id" : JSONValue.JNumber(123)])
                    expect(factory.statement(fromJSON: json)).to(beNil())
                }
                
            }
        }
    }
}