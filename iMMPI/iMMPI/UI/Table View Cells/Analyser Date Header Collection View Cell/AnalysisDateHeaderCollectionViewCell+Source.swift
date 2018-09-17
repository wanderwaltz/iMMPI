import UIKit

extension AnalysisDateHeaderCollectionViewCell {
    static func makeSource(dateFormatter: DateFormatter = .short) -> CollectionViewCellSource<Date> {
        return .withClass(
            AnalysisDateHeaderCollectionViewCell.self,
            update: { (cell: AnalysisDateHeaderCollectionViewCell, date: Date?) in
                if let date = date {
                    cell.titleLabel.text = dateFormatter.string(from: date)
                }
                else {
                    cell.titleLabel.text = ""
                }
            }
        )
    }
}
