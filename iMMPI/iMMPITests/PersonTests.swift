import XCTest
@testable import iMMPI

final class PersonTests: XCTestCase {
    func testThat__default_person_has_nonnull_name() {
        let name: String? = Person().name
        XCTAssertNotNil(name)
    }

    func testThat__default_person_has_empty_name() {
        XCTAssertTrue(Person().name.isEmpty)
    }

    func testThat__default_person_is_male() {
        XCTAssertEqual(Person().gender, .male)
    }

    func testThat__default_person_is_adult() {
        XCTAssertEqual(Person().ageGroup, .adult)
    }

    func testThat__persons_with_all_matching_properties_are_equal() {
        let person1 = Person(name: "John Doe", gender: .male, ageGroup: .adult)
        let person2 = Person(name: "John Doe", gender: .male, ageGroup: .adult)

        XCTAssertEqual(person1, person2)

        XCTAssertTrue(person1.isEqual(person2))
        XCTAssertTrue(person2.isEqual(person1))
    }

    func testThat__persons_with_all_matching_properties_have_equal_hashes() {
        let person1 = Person(name: "John Doe", gender: .male, ageGroup: .adult)
        let person2 = Person(name: "John Doe", gender: .male, ageGroup: .adult)

        XCTAssertEqual(person1.hash, person2.hash)
        XCTAssertEqual(person1.hashValue, person2.hashValue)
    }

    func testThat__persons_with_at_least_one_non_matching_property_are_not_equal() {
        let persons = [
            Person(name: "John Doe", gender: .male, ageGroup: .adult),
            Person(name: "John Appleseed", gender: .male, ageGroup: .adult),
            Person(name: "John Doe", gender: .female, ageGroup: .adult),
            Person(name: "John Doe", gender: .male, ageGroup: .teen),
            Person(name: "Mary Sue", gender: .female, ageGroup: .adult),
            Person(name: "Mary Poppins", gender: .female, ageGroup: .teen)
        ]

        for first in persons {
            for second in persons {
                if first !== second {
                    XCTAssertNotEqual(first, second)
                    XCTAssertFalse(first.isEqual(second))
                }
            }
        }
    }

    func testThat__person_is_not_equal_to_other_things() {
        let person = Person(name: "John Doe", gender: .male, ageGroup: .adult)

        XCTAssertFalse(person.isEqual("John Doe"))
        XCTAssertFalse(person.isEqual(Gender.male))
        XCTAssertFalse(person.isEqual(Gender.female))
        XCTAssertFalse(person.isEqual(Gender.unknown))
        XCTAssertFalse(person.isEqual(AgeGroup.adult))
        XCTAssertFalse(person.isEqual(AgeGroup.teen))
        XCTAssertFalse(person.isEqual(AgeGroup.unknown))
        XCTAssertFalse(person.isEqual(123))
        XCTAssertFalse(person.isEqual(true))
        XCTAssertFalse(person.isEqual(NSObject()))
        XCTAssertFalse(person.isEqual(nil))
    }

    func testThat__person_copy_has_the_same_properties() {
        let person = Person(name: "Mary Poppins", gender: .female, ageGroup: .teen)
        let clone = person.makeCopy()

        XCTAssertEqual(person.name, clone.name)
        XCTAssertEqual(person.gender, clone.gender)
        XCTAssertEqual(person.ageGroup, clone.ageGroup)
    }

    func testThat__person_copy_is_different_instance() {
        let person = Person(name: "Mary Poppins", gender: .female, ageGroup: .teen)
        let clone = person.makeCopy()

        XCTAssertTrue(person !== clone)
    }
}
