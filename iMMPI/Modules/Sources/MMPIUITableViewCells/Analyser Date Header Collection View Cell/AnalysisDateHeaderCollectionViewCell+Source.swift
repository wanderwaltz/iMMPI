import UIKit
import Formatters
import UIReusableViews

extension AnalysisDateHeaderCollectionViewCell {
    public typealias Source = CollectionViewCellSource<Date>

    public static func makeSource(dateFormatter: DateFormatter = .short) -> Source {
        return .nib(
            bundle: .module,
            update: { (cell: AnalysisDateHeaderCollectionViewCell, date: Date?) in
            if let date = date {
                cell.titleLabel?.text = dateFormatter.string(from: date)
            }
            else {
                cell.titleLabel?.text = ""
            }
        })
    }
}
