import Foundation

enum AnswerType: Int {
    case unknown
    case positive
    case negative
}


extension AnswerType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .positive: return Strings.Analysis.yes
        case .negative: return Strings.Analysis.no
        case .unknown: return Strings.Value.unknown
        }
    }
}
