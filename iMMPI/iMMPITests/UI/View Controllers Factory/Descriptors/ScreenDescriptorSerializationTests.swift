import XCTest
@testable import iMMPI

final class ScreenDescriptorSerializationTests: XCTestCase {
    let serialization = ScreenDescriptorSerialization()

    let recordIdentifier = RecordIdentifier(
        personIdentifier: PersonIdentifier(
            name: "John Appleseed"
        ),
        date: Date(
            timeIntervalSince1970: 1234
        )
    )

    let multipleRecordIdentifiers = [
        RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "John Appleseed"
            ),
            date: Date(
                timeIntervalSince1970: 1234
            )
        ),
        RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: "Leslie Knope"
            ),
            date: Date(
                timeIntervalSince1970: 5678
            )
        )
    ]

    func testThat__serialization_with_nil_argument_returns_nil() {
        XCTAssertNil(serialization.decode(nil))
    }

    func test__allRecords_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .allRecords
        )
    }

    func test__trash_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .trash
        )
    }

    func test__navigation_controller_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .navigationController
        )
    }

    func test__form_navigation_controller_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .formNavigationController
        )
    }

    func test__edit_record_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .editRecord(with: recordIdentifier)
        )
    }

    func test__details_for_single_record_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .detailsForSingleRecord(with: recordIdentifier)
        )
    }

    func test__details_for_multiple_records_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .detailsForMultipleRecords(with: multipleRecordIdentifiers)
        )
    }

    func test__analysis_for_records_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .analysisForRecords(with: multipleRecordIdentifiers)
        )
    }

    func test__answers_input_for_record_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .answersInputForRecord(with: recordIdentifier)
        )
    }

    func test__answers_review_for_record_serialization() {
        XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(
            .answersReviewForRecord(with: recordIdentifier)
        )
    }

    func testThat__invalid_restoration_id_is_not_decoded() {
        XCTAssertNil(serialization.decode("qwerty"))
    }

    private func XCTAssertDecodingRIDYieldsScreenDescriptorWithTheSameRID(_ screenDescriptor: ScreenDescriptor,
                                                                          file: StaticString = #file,
                                                                          line: UInt = #line) {
        let restorationIdentifier = screenDescriptor.restorationIdentifier
        XCTAssertNotNil(restorationIdentifier, "expected non-nil restoration identifier", file: file, line: line)

        let decodedDescriptor = serialization.decode(restorationIdentifier)
        XCTAssertNotNil(decodedDescriptor, "expected non-nil decoded descriptor", file: file, line: line)

        XCTAssertEqual(decodedDescriptor?.restorationIdentifier, restorationIdentifier, file: file, line: line)
    }
}
