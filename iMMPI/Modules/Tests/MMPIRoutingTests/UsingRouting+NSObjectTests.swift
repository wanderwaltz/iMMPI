import XCTest
import MMPIRouting
import MMPIRoutingMocks

final class UsingRoutingNSObjectTests: XCTestCase {
    final class TestObject: NSObject, UsingRouting {}

    var object: TestObject!

    override func setUp() {
        super.setUp()
        object = TestObject()
    }

    func testThat__default_router_is_nil() {
        XCTAssertNil(object.router)
    }

    func testThat__setting_router_retains_router() {
        let router = StubRouter()
        XCTAssertNil(object.router)
        object.router = router
        XCTAssertTrue(object.router === router)
    }
}
