import XCTest
import Utils

public func checkDescriptionMatchesRawValue<T: StrictlyRawRepresentable>(
    with iterator: AnyIterator<T>,
    file: StaticString = #file,
    line: UInt = #line
) where T.RawValue == String {
    for value in iterator {
        XCTAssertEqual(value.rawValue, String(describing: value))
    }
}

