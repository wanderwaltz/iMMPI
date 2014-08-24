//
//  JSONStatementFactory.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class JSONStatementFactory {
    func statement(fromJSON json: JSONValue) -> Statement? {
        if let ID = json["id"].number {
            if let text = json["text"].string {
                return Statement(ID: ID, text: text)
            }
        }
        
        return nil
    }
}