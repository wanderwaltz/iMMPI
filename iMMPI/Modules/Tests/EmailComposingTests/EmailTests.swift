import XCTest
import UnitTestingSupport
import EmailComposing

final class EmailTests: XCTestCase {
    func testHashable() {
        checkHashableImplementation(with: StringGenerator<EmailAddress>().makeIterator())
    }

    func testThat__description_matches_rawValue() {
        checkDescriptionMatchesRawValue(with: StringGenerator<EmailAddress>().makeIterator())
    }
}
