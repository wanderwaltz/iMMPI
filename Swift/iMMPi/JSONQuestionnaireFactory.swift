//
//  JSONQuestionnaireFactory.swift
//  iMMPi
//
//  Created by Egor Chiglintsev on 24.08.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

import Foundation

class JSONQuestionnaireFactory {
    init(statementFactory: JSONStatementFactory) {
        self.statementFactory = statementFactory
    }
    
    convenience init() {
        self.init(statementFactory: JSONStatementFactory())
    }
    
    func questionnaire(#data: NSData) -> Questionnaire? {
        var json = JSONValue(data as NSData!) // casting here due to a bug in SwiftyJSON: otherwise a wrong init is called
        
        var statements : [Statement] = []
    
        if let jsonStatements = json["statements"].array {
            for value in jsonStatements {
                if let statement = self.statementFactory.statement(fromJSON: value) {
                    statements.append(statement)
                }
            }
        }
        
        if statements.count > 0 {
            return DefaultQuestionnaire(statements: statements)
        }
        
        return nil
    }
    
    func questionnaire(fromBundle fileName: String) -> Questionnaire? {
        if let data = self.readData(fromBundle: fileName) {
            return self.questionnaire(data: data)
        }
        else {
            return nil
        }
    }
    
    func questionnaire(#gender: Gender, ageGroup: AgeGroup) -> Questionnaire? {
        if let fileName = self.bundleFileName(gender: gender, ageGroup: ageGroup) {
            return self.questionnaire(fromBundle: fileName)
        }
        else {
            return nil
        }
    }
    
    // MARK: - private: statement factory
    
    private let statementFactory: JSONStatementFactory
    
    // MARK: - private: bundled questionnaires
    
    private func bundleFileName(#gender: Gender, ageGroup: AgeGroup) -> String? {
        switch gender {
        case .Unknown:
            return nil
        case .Male:
            return self.bundleFileNameForMales(ageGroup: ageGroup)
        case .Female:
            return self.bundleFileNameForFemales(ageGroup: ageGroup)
        }
    }
    
    private func bundleFileNameForMales(#ageGroup: AgeGroup) -> String? {
        switch ageGroup {
        case .Unknown:
            return nil
        case .Adult:
            return "mmpi.male.adult.json"
        case .Teen:
            return "mmpi.male.teen.json"
        }
    }
    
    private func bundleFileNameForFemales(#ageGroup: AgeGroup) -> String? {
        switch ageGroup {
        case .Unknown:
            return nil
        case .Adult:
            return "mmpi.female.adult.json"
        case .Teen:
            return "mmpi.female.teen.json"
        }
    }
    
    // MARK: - private: loading data from bundle
    
    private func split(#fileName: String) -> (String, String) {
        return (fileName.stringByDeletingPathExtension, fileName.pathExtension)
    }
    
    private func readData(fromBundle fileName: String) -> NSData? {
        let bundle = NSBundle.mainBundle()
        let (name, type) = self.split(fileName: fileName)
        
        if let filePath = bundle.pathForResource(name, ofType: type) {
            var error: NSError? = nil
            
            if let data = NSData.dataWithContentsOfFile(filePath,
                options: NSDataReadingOptions.DataReadingMappedIfSafe, error:  &error) {
                    return data
            }
        }
        
        return nil
    }
}