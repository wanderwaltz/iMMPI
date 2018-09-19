import Foundation

/// Questionnaire class encapsulates an ordered array of MMPI test statements.
///
/// Questionnaries are stored in json format in the application bundle.
/// There are separate sets of questions depending on the gender and age group
/// of the person, and these are stored in separate files.
struct Questionnaire {
    fileprivate init(statements: [Statement]) {
        var statementsById: [Statement.Identifier:Statement] = [:]

        for statement in statements {
            statementsById[statement.identifier] = statement
        }

        self.statements = statements
        self.statementsById = statementsById
    }

    fileprivate let statements: [Statement]
    fileprivate let statementsById: [Statement.Identifier:Statement]
}


extension Questionnaire {
    var statementsCount: Int {
        return statements.count
    }

    func statement(at index: Int) -> Statement? {
        guard 0 <= index && index < statements.count else {
            return nil
        }

        return statements[index]
    }

    func statement(id: Statement.Identifier) -> Statement? {
        return statementsById[id]
    }
}


extension Questionnaire: Sequence {
    func makeIterator() -> IndexingIterator<[Statement]> {
        return statements.makeIterator()
    }
}


extension Questionnaire {
    enum Error: Swift.Error {
        case nilFileName
        case fileNotFound
        case jsonRootNotDictionary
        case statementsNotFound
        case statementJsonNotDictionary
        case statementIdentifierNotFound
        case statementTextNotFound
    }


    init(record: RecordProtocol) throws {
        try self.init(person: record.person)
    }


    init(person: Person) throws {
        try self.init(gender: person.gender, ageGroup: person.ageGroup)
    }


    /// Initializes a Questionnarie object with the gender and age group values.
    ///
    /// This method does load and parse the json file corresponding the provided 
    /// gender and age group values. Throws an error if something goes wrong while
    /// loading the data.
    ///
    /// - Parameters:
    ///     - gender:   Gender value of the `Questionnaire`,
    ///     - ageGroup: Age group value of the `Questionnaire`
    init(gender: Gender, ageGroup: AgeGroup) throws {
        guard let fileName = questionnaireFileNames[gender]?[ageGroup], fileName.isEmpty == false else {
            throw Error.nilFileName
        }

        try self.init(resourceName: fileName)
    }


    init(resourceName: String, bundle: Bundle = .main) throws {
        guard let path = bundle.path(forResource: resourceName, ofType: questionnaireFilePathExtension),
            path.isEmpty == false else {
                throw Error.fileNotFound
        }

        try self.init(url: URL(fileURLWithPath: path))
    }


    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [])

        guard let jsonDictionary = json as? [String:Any] else {
            throw Error.jsonRootNotDictionary
        }

        guard let statementsRaw = jsonDictionary[Key.statements] as? [Any] else {
            throw Error.statementsNotFound
        }

        var statements: [Statement] = []

        for jsonStatementRaw in statementsRaw {
            guard let jsonStatement = jsonStatementRaw as? [String:Any] else {
                throw Error.statementJsonNotDictionary
            }

            guard let id = jsonStatement[Key.id] as? Int else {
                throw Error.statementIdentifierNotFound
            }

            guard let text = jsonStatement[Key.text] as? String else {
                throw Error.statementTextNotFound
            }

            statements.append(Statement(identifier: id, text: text))
        }

        statements.sort(by: { (a, b) in a.identifier < b.identifier })
        
        self.init(statements: statements)
    }
}


fileprivate let questionnaireFilePathExtension = "json"


fileprivate enum Key {
    static let statements = "statements"
    static let id = "id"
    static let text = "text"
}


fileprivate let questionnaireFileNames: [Gender:[AgeGroup:String]] = [
    .male: [
        .adult: "mmpi.male.adult",
        .teen:  "mmpi.male.teen"
    ],

    .female: [
        .adult: "mmpi.female.adult",
        .teen:  "mmpi.female.teen"
    ]
]
