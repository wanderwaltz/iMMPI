import XCTest
@testable import iMMPI

final class AnalysisDateHeaderCollectionViewCellTests: XCTestCase {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let source = AnalysisDateHeaderCollectionViewCell.makeSource()

    override func setUp() {
        super.setUp()
        collectionView.dataSource = self
        source.register(in: collectionView)
    }

    func makeCell(with date: Date?) -> AnalysisDateHeaderCollectionViewCell {
        return source.dequeue(
            from: collectionView,
            for: IndexPath(
                row: 0,
                section: 0
            ),
            with: date
        )
        as! AnalysisDateHeaderCollectionViewCell
    }

    func testThat__it_displays_date_using_short_formatter() {
        let expectedDate = Date(timeIntervalSince1970: 123)
        let cell = makeCell(with: expectedDate)

        XCTAssertEqual(cell.titleLabel.text, DateFormatter.short.string(from: expectedDate))
    }

    func testThat__it_sets_empty_text_when_updated_with_nil_date() {
        let cell = makeCell(with: nil)

        XCTAssertEqual(cell.titleLabel.text, "")
    }

    func testThat__its_text_is_initially_empty() {
        let cell = AnalysisDateHeaderCollectionViewCell(frame: .zero)

        XCTAssertEqual(cell.titleLabel.text, "")
    }
}


// `UICollectionView` has to have an actual data source so that dequeueing cells from it does not crash
extension AnalysisDateHeaderCollectionViewCellTests: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return source.dequeue(from: collectionView, for: indexPath, with: nil)
    }
}
