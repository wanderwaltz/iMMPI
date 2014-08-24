//
//  Statement.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

struct Statement {
    let ID: Int
    let text: String
}

extension Statement : Equatable {
}

func ==(left: Statement, right: Statement) -> Bool {
    return (left.ID == right.ID) && (left.text == right.text)
}