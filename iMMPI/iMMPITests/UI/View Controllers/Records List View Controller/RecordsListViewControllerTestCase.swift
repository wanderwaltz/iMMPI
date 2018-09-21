import XCTest
@testable import iMMPI

class RecordsListViewControllerTestCase: MMPIViewControllersFactoryTestCase {
    var recordsListVC: RecordsListViewController!
    var router: StubRouter!

    var screenDescriptor: ScreenDescriptor {
        return .allRecords
    }

    enum Records {
        static let john = Record(
            person: Person(
                name: "John Appleseed",
                gender: .male,
                ageGroup: .adult
            ),
            answers: Answers(),
            date: Date(
                timeIntervalSince1970: 0
            )
        )

        static let leslieOlder = Record(
            person: Person(
                name: "Leslie Knope",
                gender: .female,
                ageGroup: .adult
            ),
            answers: Answers(),
            date: Date(
                timeIntervalSince1970: 0
            )
        )

        static let leslieRecent = Record(
            person: Person(
                name: "Leslie Knope",
                gender: .female,
                ageGroup: .adult
            ),
            answers: Answers(),
            date: Date(
                timeIntervalSince1970: 3600 * 24 + 1
            )
        )
    }

    override func setUp() {
        storage = StubRecordStorage(records: [Records.john, Records.leslieOlder, Records.leslieRecent])
        super.setUp()
        recordsListVC = viewControllersFactory.makeViewController(for: screenDescriptor) as? RecordsListViewController
        router = StubRouter()
        recordsListVC.router = router
    }

    func reloadViewControllerData(for viewController: RecordsListViewController? = nil) {
        let itReloadsDataExpectation = expectation(description: "view controller model finishes loading")
        (viewController ?? recordsListVC)?.viewModel?.setNeedsUpdate(completion: { _ in
            itReloadsDataExpectation.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
