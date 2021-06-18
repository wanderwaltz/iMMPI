import Foundation
import DataModel
import Analysis
import Formatters

public final class ScaleDetailsViewModel {
    private let record: RecordProtocol
    private let scale: AnalysisScale

    public init(record: RecordProtocol, scale: AnalysisScale) {
        self.record = record
        self.scale = scale
    }
}

extension ScaleDetailsViewModel {
    var title: String {
        "\(DateFormatter.short.string(from: record.date)) – \(scale.title)"
    }
}
