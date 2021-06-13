import UIKit
import Formatters

extension AnalysisDateHeaderCollectionViewCell {
    typealias Source = CollectionViewCellSource<Date>

    static func makeSource(dateFormatter: DateFormatter = .short) -> Source {
        return .nib(update: { (cell: AnalysisDateHeaderCollectionViewCell, date: Date?) in
            if let date = date {
                cell.titleLabel?.text = dateFormatter.string(from: date)
            }
            else {
                cell.titleLabel?.text = ""
            }
        })
    }
}
