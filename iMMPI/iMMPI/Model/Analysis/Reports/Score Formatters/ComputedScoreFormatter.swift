import Foundation
import Analysis

struct ComputedScoreFormatter {
    let format: (ComputedScore) -> String

    init(_ format: @escaping (ComputedScore) -> String) {
        self.format = format
    }
}
