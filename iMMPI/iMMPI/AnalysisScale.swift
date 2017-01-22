import Foundation

struct AnalysisScale {
    let identifier: Identifier
    let title: String

    init(identifier: Identifier, title: String, score: @escaping (TestRecordProtocol) -> Double) {
        self.identifier = identifier
        self.title = title
        self.computeScore = score
    }

    fileprivate let computeScore: (TestRecordProtocol) -> Double
}


extension AnalysisScale {
    func score(for record: TestRecordProtocol) -> Double {
        return computeScore(record)
    }
}


extension AnalysisScale {
    struct Identifier {
        let rawValue: String

        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }

}


extension AnalysisScale.Identifier: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}


extension AnalysisScale.Identifier: Hashable {
    var hashValue: Int {
        return rawValue.hashValue
    }


    static func == (left: AnalysisScale.Identifier, right: AnalysisScale.Identifier) -> Bool {
        return left.rawValue == right.rawValue
    }
}
