import XCTest
@testable import iMMPI

final class RecordLazyLoadingTests: XCTestCase {
    var indexItem: RecordIndexItem!

    override func setUp() {
        super.setUp()
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()

        dateComponents.year = 2000
        dateComponents.month = 11
        dateComponents.day = 25

        indexItem = RecordIndexItem(
            personName: "John Appleseed",
            date: calendar.date(from: dateComponents)!
        )
    }

    func testThat__proxy_initialized_with_index_item__is_not_initially_materialized() {
        XCTAssertFalse(indexItem.makeLazy().isMaterialized)
    }

    func testThat__proxy_initialized_with_index_item__has_corresponding_person_name() {
        XCTAssertEqual(indexItem.makeLazy().indexItem.personName, indexItem.personName)
    }

    func testThat__proxy_initialized_with_index_item__has_corresponding_date() {
        XCTAssertEqual(indexItem.makeLazy().date, indexItem.date)
    }

    func testThat__reading__identifier__does_not_materialize_proxy() {
        let proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.identifier
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__person_name__does_not_materialize_proxy() {
        let proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.indexItem.personName
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__date__does_not_materialize_proxy() {
        let proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.date
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__person__does_materialize_proxy() {
        let proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.person
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__reading__answers__does_materialize_proxy() {
        let proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.answers
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__date__does_materialize_proxy() {
        var proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.date = Date.distantPast
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__date__does_update_record_date() {
        var proxy = indexItem.makeLazy()

        XCTAssertNotEqual(proxy.date, Date.distantPast)
        proxy.date = Date.distantPast
        XCTAssertEqual(proxy.date, Date.distantPast)
    }

    func testThat__writing__date__keeps_person_name() {
        var proxy = indexItem.makeLazy()

        let personName = proxy.indexItem.personName
        proxy.date = Date.distantPast
        XCTAssertEqual(personName, proxy.indexItem.personName)
    }

    func testThat__writing__person__does_materialize_proxy() {
        var proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.person = Person()
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__person__updates_record_person() {
        var proxy = indexItem.makeLazy()
        let newPerson = Person(name: "Leslie Knope", gender: .female, ageGroup: .adult)

        XCTAssertNotEqual(proxy.person.name, newPerson.name)
        proxy.person = newPerson
        XCTAssertEqual(proxy.person.name, newPerson.name)
    }

    func testThat__writing__answers__does_materialize_proxy() {
        var proxy = indexItem.makeLazy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.answers = Answers()
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__materialized_proxy__ignores_index_item_date() {
        let record = Record()
        let proxy = Record(indexItem: indexItem, materialize: Constant.value(record))

        _ = proxy.answers
        XCTAssertNotEqual(proxy.date, indexItem.date)
        XCTAssertEqual(proxy.date, record.date)
    }

    func testThat__proxy_description_contains_person_name() {
        XCTAssertTrue(indexItem.makeLazy().description.contains(indexItem.personName))
    }
}
