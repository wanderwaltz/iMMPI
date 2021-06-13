import Foundation
import DataModel

public struct JSONAnswersSerialization {
    let answerType: JSONAnswerTypeSerialization

    public init(answerType: JSONAnswerTypeSerialization = .init()) {
        self.answerType = answerType
    }
}

extension JSONAnswersSerialization {
    public func encode(_ answers: Answers) -> [[String:Any]] {
        var result: [[String:Any]] = []

        answers.enumerateAnswers { identifier, answer in
            result.append([
                Key.identifier: identifier,
                Key.answer: answerType.encode(answer)
                ])
        }

        return result
    }

    public func decode(_ value: Any?) -> Answers? {
        guard let json = value as? [[String:Any]] else {
            return nil
        }

        var positive: [Statement.Identifier] = []
        var negative: [Statement.Identifier] = []
        
        for answerJson in json {
            guard let identifier = answerJson[Key.identifier] as? Int else {
                    continue
            }

            switch answerType.decode(answerJson[Key.answer]) {
            case .positive: positive.append(identifier)
            case .negative: negative.append(identifier)
            case .unknown: break
            }
        }

        return Answers(positive: positive, negative: negative)
    }
}

extension JSONAnswersSerialization {
    enum Key {
        static let identifier = "id"
        static let answer = "answer"
    }
}
