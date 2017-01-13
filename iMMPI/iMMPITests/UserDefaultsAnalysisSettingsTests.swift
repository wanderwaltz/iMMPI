import XCTest
@testable import iMMPI

final class AnalysisSettingsTests: XCTestCase {
    var defaults: TestDefaults!

    class TestDefaults: UserDefaults {
        var synchronizeCallsCount = 0

        override func synchronize() -> Bool {
            synchronizeCallsCount += 1
            return true
        }
    }

    override func setUp() {
        super.setUp()
        defaults = TestDefaults()
    }


    func testThat__it_has_standard_defaults_by_default() {
        let settings = UserDefaultsAnalysisSettings()
        XCTAssertTrue(settings.defaults === UserDefaults.standard)
    }


    func testThat__it_has_a_nonempty_filterKey_by_default() {
        let settings = UserDefaultsAnalysisSettings()
        XCTAssertFalse(settings.filterKey.isEmpty)
    }


    func testThat__it_has_a_nonempty_hideNormKey_by_default() {
        let settings = UserDefaultsAnalysisSettings()
        XCTAssertFalse(settings.hideNormKey.isEmpty)
    }


    func testThat__it_has_distinct_filterKey_and_hideNormKey_by_default() {
        let settings = UserDefaultsAnalysisSettings()
        XCTAssertNotEqual(settings.filterKey, settings.hideNormKey)
    }


    func testThat__it_reads_using_the_filterKey_when_reading_shouldFilterResults() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        defaults.set(true, forKey: settings.filterKey)
        XCTAssertTrue(settings.shouldFilterResults)

        defaults.set(false, forKey: settings.filterKey)
        XCTAssertFalse(settings.shouldFilterResults)
    }


    func testThat__it_writes_using_the_filterKey_when_writing_shouldFilterResults() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        settings.shouldFilterResults = true
        XCTAssertTrue(defaults.bool(forKey: settings.filterKey))

        settings.shouldFilterResults = false
        XCTAssertFalse(defaults.bool(forKey: settings.filterKey))
    }


    func testThat__it_synchronises_the_defaults_each_time_shouldFilterResults_is_set() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        XCTAssertEqual(defaults.synchronizeCallsCount, 0)

        settings.shouldFilterResults = true
        XCTAssertEqual(defaults.synchronizeCallsCount, 1)

        settings.shouldFilterResults = false
        XCTAssertEqual(defaults.synchronizeCallsCount, 2)
    }


    func testThat__it_reads_using_the_hideNormKey_when_reading_shouldHideNormalResults() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        defaults.set(true, forKey: settings.hideNormKey)
        XCTAssertTrue(settings.shouldHideNormalResults)

        defaults.set(false, forKey: settings.hideNormKey)
        XCTAssertFalse(settings.shouldHideNormalResults)
    }


    func testThat__it_writes_using_the_hideNormKey_when_writing_shouldHideNormalResults() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        settings.shouldHideNormalResults = true
        XCTAssertTrue(defaults.bool(forKey: settings.hideNormKey))

        settings.shouldHideNormalResults = false
        XCTAssertFalse(defaults.bool(forKey: settings.hideNormKey))
    }


    func testThat__it_synchronises_the_defaults_each_time_shouldHideNormalResults_is_set() {
        let settings = UserDefaultsAnalysisSettings(defaults: defaults)

        XCTAssertEqual(defaults.synchronizeCallsCount, 0)

        settings.shouldHideNormalResults = true
        XCTAssertEqual(defaults.synchronizeCallsCount, 1)

        settings.shouldHideNormalResults = false
        XCTAssertEqual(defaults.synchronizeCallsCount, 2)
    }
}
