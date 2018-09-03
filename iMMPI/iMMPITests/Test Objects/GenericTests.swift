import XCTest
@testable import iMMPI

func checkHashableImplementation<T: Hashable>(with iterator: AnyIterator<T>) {
    let all = Array(iterator)
    for (i1, v1) in all.enumerated() {
        for (i2, v2) in all.enumerated() {
            if i1 == i2 {
                XCTAssertEqual(v1, v2)
                XCTAssertEqual(v1.hashValue, v2.hashValue)
            }
            else {
                if v1 == v2 {
                    XCTAssertEqual(v1.hashValue, v2.hashValue)
                }

                if v1.hashValue != v2.hashValue {
                    XCTAssertNotEqual(v1, v2)
                }
            }
        }
    }
}


func checkDescriptionMatchesRawValue<T: StrictlyRawRepresentable>(with iterator: AnyIterator<T>)
    where T.RawValue == String {
        for value in iterator {
            XCTAssertEqual(value.rawValue, String(describing: value))
        }
}
