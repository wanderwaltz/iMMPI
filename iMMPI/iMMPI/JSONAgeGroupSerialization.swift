import Foundation

struct JSONAgeGroupSerialization {
    func encode(_ ageGroup: AgeGroup) -> String {
        switch ageGroup {
        case .adult: return Value.adult
        case .teen: return Value.teen
        case .unknown: return Value.unknown
        }
    }

    func decode(_ value: Any?) -> AgeGroup {
        switch value as? String {
        case .some(Value.adult): return .adult
        case .some(Value.teen): return .teen
        default: return .unknown
        }
    }
}


extension JSONAgeGroupSerialization {
    enum Value {
        static let adult = "adult"
        static let teen = "teen"
        static let unknown = "unknown"
    }
}
