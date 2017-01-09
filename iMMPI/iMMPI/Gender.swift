import Foundation

extension Gender {
    func toggled() -> Gender {
        switch self {
        case .male: return .female
        case .female: return .male
        case .unknown: return .male
        }
    }
}


extension Gender: CustomStringConvertible {
    public var description: String {
        switch self {
        case .male: return Strings.genderMale
        case .female: return Strings.genderFemale
        case .unknown: return Strings.unknown
        }
    }
}
