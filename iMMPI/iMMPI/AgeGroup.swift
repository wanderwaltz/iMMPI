import Foundation

enum AgeGroup: Int {
    case unknown
    case teen
    case adult
}


extension AgeGroup {
    func toggled() -> AgeGroup {
        switch self {
        case .adult: return .teen
        case .teen: return .adult
        case .unknown: return .adult
        }
    }
}


extension AgeGroup: CustomStringConvertible {
    public var description: String {
        switch self {
        case .adult: return Strings.Value.ageGroupAdult
        case .teen: return Strings.Value.ageGroupTeen
        case .unknown: return Strings.Value.unknown
        }
    }
}
