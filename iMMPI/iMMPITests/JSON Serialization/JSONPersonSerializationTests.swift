import XCTest
@testable import iMMPI

final class JSONPersonSerializationTests: XCTestCase {
    var serialization: JSONPersonSerialization!

    override func setUp() {
        super.setUp()
        serialization = JSONPersonSerialization()
    }

    func testThat__serialization_is_bidirectional() {
        let first = Person(name: "John Appleseed", gender: .male, ageGroup: .adult)
        let second = Person(name: "Mary Poppins", gender: .female, ageGroup: .teen)

        let firstSerialized = serialization.encode(first)
        let secondSerialized = serialization.encode(second)

        let firstDeserialized = serialization.decode(firstSerialized)
        let secondDeserialized = serialization.decode(secondSerialized)

        XCTAssertMemberwiseEqual(first, firstDeserialized)
        XCTAssertMemberwiseEqual(second, secondDeserialized)

        XCTAssertNotMemberwiseEqual(first, secondDeserialized)
        XCTAssertNotMemberwiseEqual(second, firstDeserialized)
    }


    func test__decode__only_name() {
        let person = serialization.decode(["name": "John Appleseed"] as [String:String])!

        XCTAssertEqual(person.name, "John Appleseed")
        XCTAssertEqual(person.ageGroup, .unknown)
        XCTAssertEqual(person.gender, .unknown)
    }


    func test__decode__invalid() {
        XCTAssertNil(serialization.decode(nil))
        XCTAssertNil(serialization.decode(123))
        XCTAssertNil(serialization.decode("qwerty"))
        XCTAssertNil(serialization.decode([
            "ageGroup": "adult",
            "gender": "male"
            ] as [String:String]))
    }
}
