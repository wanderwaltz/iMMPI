import XCTest
@testable import iMMPI

final class MMPIViewControllerFactoryNavigationControllerTests: MMPIViewControllersFactoryTestCase {
    func testThat__created_navigation_controller_is_a_UINavigationController() {
        let navigationController = viewControllersFactory.makeViewController(for: .navigationController)
        XCTAssertTrue(navigationController is UINavigationController)
    }

    func testThat__created_navigation_controller_has_non_nil_restoration_identifier() {
        let navigationController = viewControllersFactory.makeViewController(for: .navigationController)
        XCTAssertNotNil(navigationController.restorationIdentifier)
    }

    func testThat__created_navigation_controller_has_nil_restoration_class() {
        let navigationController = viewControllersFactory.makeViewController(for: .navigationController)
        XCTAssertNil(navigationController.restorationClass)
    }

    func testThat__created_navigation_controller_has_default_modal_presentation_style() {
        let navigationController = viewControllersFactory.makeViewController(for: .navigationController)
        let defaultPresentationStyle = UIViewController().modalPresentationStyle
        XCTAssertEqual(navigationController.modalPresentationStyle, defaultPresentationStyle)
    }

    func testThat__created_form_navigation_controller_is_a_UINavigationController() {
        let formNavigationController = viewControllersFactory.makeViewController(for: .formNavigationController)
        XCTAssertTrue(formNavigationController is UINavigationController)
    }

    func testThat__created_form_navigation_controller_has_non_nil_restoration_identifier() {
        let formNavigationController = viewControllersFactory.makeViewController(for: .formNavigationController)
        XCTAssertNotNil(formNavigationController.restorationIdentifier)
    }

    func testThat__created_form_navigation_controller_has_nil_restoration_class() {
        let formNavigationController = viewControllersFactory.makeViewController(for: .formNavigationController)
        XCTAssertNil(formNavigationController.restorationClass)
    }

    func testThat__created_form_navigation_controller_has_form_presentation_style() {
        let formNavigationController = viewControllersFactory.makeViewController(for: .formNavigationController)
        XCTAssertEqual(formNavigationController.modalPresentationStyle, .formSheet)
    }

    func testThat__default_and_form_navigation_controllers_have_different_restoration_identifiers() {
        let navigationController = viewControllersFactory.makeViewController(for: .navigationController)
        let formNavigationController = viewControllersFactory.makeViewController(for: .formNavigationController)
        XCTAssertNotEqual(navigationController.restorationIdentifier, formNavigationController.restorationIdentifier)
    }
}
