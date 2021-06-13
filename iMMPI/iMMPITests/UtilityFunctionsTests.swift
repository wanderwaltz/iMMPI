import XCTest
import UIKit
import HTMLComposing
import Utils
@testable import iMMPI

final class UtilityFunctionsTests: XCTestCase {
    func test_setting_empty_back_button_title() {
        let controller = UIViewController()
        XCTAssertNotEqual(controller.navigationItem.backBarButtonItem?.title, " ")
        controller.setEmptyBackBarButtonTitle()
        XCTAssertEqual(controller.navigationItem.backBarButtonItem?.title, " ")
    }

    func testThat__constant_bool__always_returns_the_given_value() {
        let constantTrue: (Any, Any) -> Bool = Constant.value(true)
        let constantFalse: (Any, Any) -> Bool = Constant.value(false)

        XCTAssertTrue(constantTrue(1, 1))
        XCTAssertTrue(constantTrue(1, false))
        XCTAssertTrue(constantTrue("qwerty", 1))
        XCTAssertTrue(constantTrue(123, 456))
        XCTAssertTrue(constantTrue(NSObject(), Date()))


        XCTAssertFalse(constantFalse(1, 1))
        XCTAssertFalse(constantFalse(1, false))
        XCTAssertFalse(constantFalse("qwerty", 1))
        XCTAssertFalse(constantFalse(123, 456))
        XCTAssertFalse(constantFalse(NSObject(), Date()))
    }


    func testThat__constant_string__always_returns_the_given_value() {
        let qwerty: (Any) -> String = Constant.value("qwerty")

        XCTAssertEqual(qwerty(123), "qwerty")
        XCTAssertEqual(qwerty("asdfg"), "qwerty")
        XCTAssertEqual(qwerty(false), "qwerty")
        XCTAssertEqual(qwerty(true), "qwerty")
        XCTAssertEqual(qwerty(NSObject()), "qwerty")
        XCTAssertEqual(qwerty(Date()), "qwerty")
    }


    func testThat__constant_array__always_returns_the_given_value() {
        let qwerty: (Any) -> [Int] = Constant.value([1,2,3,4])

        XCTAssertEqual(qwerty(123), [1,2,3,4])
        XCTAssertEqual(qwerty("asdfg"), [1,2,3,4])
        XCTAssertEqual(qwerty(false), [1,2,3,4])
        XCTAssertEqual(qwerty(true), [1,2,3,4])
        XCTAssertEqual(qwerty(NSObject()), [1,2,3,4])
        XCTAssertEqual(qwerty(Date()), [1,2,3,4])
    }


    func testThat__constant_html__always_returns_the_given_value() {
        let expectedHtml = Html.document(.body(.content("html body")))
        let html: (Any) -> Html = Constant.value(expectedHtml)

        XCTAssertEqual(html(123), expectedHtml)
        XCTAssertEqual(html("asdfg"), expectedHtml)
        XCTAssertEqual(html(false), expectedHtml)
        XCTAssertEqual(html(true), expectedHtml)
        XCTAssertEqual(html(NSObject()), expectedHtml)
        XCTAssertEqual(html(Date()), expectedHtml)
    }


    func testThat__constant_void__does_not_have_side_effects() {
        let void: (Any) -> Void = Constant.value(())

        let expectedArray: NSMutableArray = [1,2,3]
        let array = expectedArray
        void(array)
        XCTAssertEqual(array, expectedArray)
        XCTAssertTrue(array.isEqual(expectedArray))
    }
}
