import XCTest
@testable import iMMPI

final class MMPIViewControllerRestorationUINavigationControllerTests: MMPIViewControllersFactoryTestCase {
    func testThat__navigation_controller_can_be_restored() {
        let navigationController = MMPIViewControllerRestoration.viewController(
            withRestorationIdentifierPath: [
                ScreenDescriptorSerialization.RestorationIdentifier.navigationController
            ],
            coder: NSCoder()
        )

        XCTAssertNotNil(navigationController)
        XCTAssertTrue(navigationController is UINavigationController)
        XCTAssertEqual(navigationController?.modalPresentationStyle, UIViewController().modalPresentationStyle)

        XCTAssertEqual(
            navigationController?.restorationIdentifier,
            ScreenDescriptorSerialization.RestorationIdentifier.navigationController
        )
    }

    func testThat__form_navigation_controller_can_be_restored() {
        let formNavigationController = MMPIViewControllerRestoration.viewController(
            withRestorationIdentifierPath: [
                ScreenDescriptorSerialization.RestorationIdentifier.formNavigationController
            ],
            coder: NSCoder()
        )

        XCTAssertNotNil(formNavigationController)
        XCTAssertTrue(formNavigationController is UINavigationController)
        XCTAssertEqual(formNavigationController?.modalPresentationStyle, .formSheet)

        XCTAssertEqual(
            formNavigationController?.restorationIdentifier,
            ScreenDescriptorSerialization.RestorationIdentifier.formNavigationController
        )
    }
}
