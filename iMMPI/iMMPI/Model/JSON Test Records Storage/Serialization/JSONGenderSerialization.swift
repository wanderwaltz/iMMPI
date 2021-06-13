import Foundation
import DataModel

struct JSONGenderSerialization {
    func encode(_ gender: Gender) -> String {
        switch gender {
        case .male: return Value.male
        case .female: return Value.female
        case .unknown: return Value.unknown
        }
    }

    func decode(_ value: Any?) -> Gender {
        switch value as? String {
        case .some(Value.male): return .male
        case .some(Value.female): return .female
        default: return .unknown
        }
    }
}


extension JSONGenderSerialization {
    enum Value {
        static let male = "male"
        static let female = "female"
        static let unknown = "unknown"
    }
}

