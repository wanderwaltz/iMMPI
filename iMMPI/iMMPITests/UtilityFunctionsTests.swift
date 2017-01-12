import XCTest
import UIKit
@testable import iMMPI

final class UtilityFunctionsTests: XCTestCase {
    func test_setting_empty_back_button_title() {
        let controller = UIViewController()
        XCTAssertNotEqual(controller.navigationItem.backBarButtonItem?.title, " ")
        controller.setEmptyBackBarButtonTitle()
        XCTAssertEqual(controller.navigationItem.backBarButtonItem?.title, " ")
    }


    func test_uppercasedFirstCharacter() {
        XCTAssertEqual("".uppercasedFirstCharacter, "")
        XCTAssertEqual("apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("Apple".uppercasedFirstCharacter, "A")
        XCTAssertEqual("two words".uppercasedFirstCharacter, "T")
        XCTAssertEqual("123".uppercasedFirstCharacter, "1")
        XCTAssertEqual("qwerty asdfg eiy".uppercasedFirstCharacter, "Q")
    }


    func testThat__constant_bool__always_returns_the_given_value() {
        let constantTrue: (Any, Any) -> Bool = Constant.bool(true)
        let constantFalse: (Any, Any) -> Bool = Constant.bool(false)

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
        let qwerty: (Any) -> String = Constant.string("qwerty")

        XCTAssertEqual(qwerty(123), "qwerty")
        XCTAssertEqual(qwerty("asdfg"), "qwerty")
        XCTAssertEqual(qwerty(false), "qwerty")
        XCTAssertEqual(qwerty(true), "qwerty")
        XCTAssertEqual(qwerty(NSObject()), "qwerty")
        XCTAssertEqual(qwerty(Date()), "qwerty")
    }


    func testThat__constant_void__does_not_have_side_effects() {
        let void: (Any) -> Void = Constant.void()

        let expectedArray: NSMutableArray = [1,2,3]
        let array = expectedArray
        void(array)
        XCTAssertEqual(array, expectedArray)
        XCTAssertTrue(array.isEqual(expectedArray))
    }
}
