import Foundation

struct JSONAnswerTypeSerialization {
    func encode(_ answerType: AnswerType) -> String {
        switch answerType {
        case .positive: return Value.positive
        case .negative: return Value.negative
        case .unknown: return Value.unknown
        }
    }

    func decode(_ value: Any?) -> AnswerType {
        switch value as? String {
        case .some(Value.positive): return .positive
        case .some(Value.negative): return .negative
        default: return .unknown
        }
    }
}


extension JSONAnswerTypeSerialization {
    enum Value {
        static let positive = "YES"
        static let negative = "NO"
        static let unknown = "unknown"
    }
}
