import XCTest
import UITableViewModels

final class GroupingAlphabeticallyTests: XCTestCase {
    func test__grouping_alphabetically() {
        let grouping = ["abbA", "boris", "Burger", "bAd", "Corn", "cake"].groupAlphabetically(by: { $0 })
        XCTAssertEqual(grouping.allItems, ["abbA", "bAd", "boris", "Burger", "cake", "Corn"])

        XCTAssertEqual(grouping.numberOfSections, 3)

        XCTAssertEqual(grouping.title(forSection: 0), "A")
        XCTAssertEqual(grouping.title(forSection: 1), "B")
        XCTAssertEqual(grouping.title(forSection: 2), "C")

        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 0)), "abbA")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 1)), "bAd")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 1, section: 1)), "boris")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 2, section: 1)), "Burger")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 0, section: 2)), "cake")
        XCTAssertEqual(grouping.item(at: IndexPath(row: 1, section: 2)), "Corn")
    }
}
