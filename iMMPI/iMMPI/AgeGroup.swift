import Foundation

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
        case .adult: return Strings.ageGroupAdult
        case .teen: return Strings.ageGroupTeen
        case .unknown: return Strings.unknown
        }
    }
}
