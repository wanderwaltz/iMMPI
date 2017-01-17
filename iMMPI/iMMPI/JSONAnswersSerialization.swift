import Foundation

struct JSONAnswersSerialization {
    let answerType: JSONAnswerTypeSerialization

    init(answerType: JSONAnswerTypeSerialization = JSONAnswerTypeSerialization()) {
        self.answerType = answerType
    }
}


extension JSONAnswersSerialization {
    func encode(_ answers: TestAnswersProtocol) -> [[String:Any]] {
        var result: [[String:Any]] = []

        answers.enumerateAnswers { identifier, answer in
            result.append([
                Key.identifier: identifier,
                Key.answer: answerType.encode(answer)
                ])
        }

        return result
    }


    func decode(_ value: Any?) -> TestAnswers? {
        guard let json = value as? [[String:Any]] else {
            return nil
        }

        let answers = TestAnswers()
        
        for answerJson in json {
            guard let identifier = answerJson[Key.identifier] as? Int,
                case let answer = answerType.decode(answerJson[Key.answer]), answer != .unknown else {
                    continue
            }

            answers.setAnswer(answer, for: identifier)
        }

        return answers
    }
}


extension JSONAnswersSerialization {
    enum Key {
        static let identifier = "id"
        static let answer = "answer"
    }
}
