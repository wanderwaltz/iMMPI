import XCTest
import Utils
@testable import iMMPI

final class AsyncProviderTests: XCTestCase {
    func testThat__it_provides_data_from_the_provide_closure() {
        let provider = AsyncProvider<Int>({ completion in
            completion(123)
        })

        let expectation = self.expectation(description: "it provides the value")

        var receivedValue = 0
        provider.provide({ value in
            receivedValue = value
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.125)
        XCTAssertEqual(receivedValue, 123)
    }


    func testThat__it_calls_provide_closure_each_time_provide_is_called() {
        var callsCount = 0

        let provider = AsyncProvider<Int>({ completion in
            callsCount += 1
            completion(123)
        })

        provider.provide(Constant.value(()))
        provider.provide(Constant.value(()))
        provider.provide(Constant.value(()))

        XCTAssertEqual(callsCount, 3)
    }


    func testThat__constant_provider_provides_constant_value() {
        let provider = AsyncProvider<Int>(constant: 123)

        let expectation = self.expectation(description: "it provides the value")

        var receivedValue = 0
        provider.provide({ value in
            receivedValue = value
            expectation.fulfill()
        })

        waitForExpectations(timeout: 0.125)
        XCTAssertEqual(receivedValue, 123)
    }
}
