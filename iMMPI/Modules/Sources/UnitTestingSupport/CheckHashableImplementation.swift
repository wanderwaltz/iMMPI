import XCTest

public func checkHashableImplementation<T: Hashable>(
    with iterator: AnyIterator<T>,
    file: StaticString = #file,
    line: UInt = #line
) {
    let all = Array(iterator)
    for (i1, v1) in all.enumerated() {
        for (i2, v2) in all.enumerated() {
            if i1 == i2 {
                XCTAssertEqual(v1, v2, file: file, line: line)
                XCTAssertEqual(v1.hashValue, v2.hashValue, file: file, line: line)
            }
            else {
                if v1 == v2 {
                    XCTAssertEqual(v1.hashValue, v2.hashValue, file: file, line: line)
                }

                if v1.hashValue != v2.hashValue {
                    XCTAssertNotEqual(v1, v2, file: file, line: line)
                }
            }
        }
    }
}
