//
//  GenderSpec.swift
//  iMMPiTests
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class GenderSpec: QuickSpec {
    override func spec() {
        describe("Gender") {
            context("when created from a string value") {
                it("should return Gender.Male for string 'male'") {
                    expect(Gender.fromString("male")).to(equal(Gender.Male))
                }
                
                it("should return Gender.Female for string 'female'") {
                    expect(Gender.fromString("female")).to(equal(Gender.Female))
                }
                
                it("should return Gender.Unknown for any other string") {
                    expect(Gender.fromString("not a gender string")).to(equal(Gender.Unknown))
                }
            }
        }
    }
}