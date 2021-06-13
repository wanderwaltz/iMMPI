import Foundation
import Analysis

public struct ComputedScoreFormatter {
    public let format: (ComputedScore) -> String

    init(_ format: @escaping (ComputedScore) -> String) {
        self.format = format
    }
}
