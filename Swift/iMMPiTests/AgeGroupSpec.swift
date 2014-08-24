//
//  AgeGroupSpec.swift
//  iMMPiTests
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Quick
import Nimble

class AgeGroupSpec: QuickSpec {
    override func spec() {
        describe("AgeGroup") {
            context("when created from a string value") {
                it("should return AgeGroup.Adult for string 'adult'") {
                    expect(AgeGroup.fromString("adult")).to(equal(AgeGroup.Adult))
                }
                
                it("should return AgeGroup.Teen for string 'teen'") {
                    expect(AgeGroup.fromString("teen")).to(equal(AgeGroup.Teen))
                }
                
                it("should return AgeGroup.Unknown for any other string") {
                    expect(AgeGroup.fromString("not an age group string")).to(equal(AgeGroup.Unknown))
                }
            }
        }
    }
}