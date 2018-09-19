import XCTest
@testable import iMMPI

final class RecordProxyTests: XCTestCase {
    typealias Proxy = RecordProxy<StubRecordIndexItem>

    var indexItem: StubRecordIndexItem!

    override func setUp() {
        super.setUp()
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()

        dateComponents.year = 2000
        dateComponents.month = 11
        dateComponents.day = 25

        indexItem = StubRecordIndexItem(personName: "John Appleseed", date: calendar.date(from: dateComponents)!)
    }

    func testThat__proxy_initialized_with_index_item__is_not_initially_materialized() {
        XCTAssertFalse(indexItem.makeProxy().isMaterialized)
    }

    func testThat__proxy_initialized_with_index_item__has_corresponding_person_name() {
        XCTAssertEqual(indexItem.makeProxy().personName, indexItem.personName)
    }

    func testThat__proxy_initialized_with_index_item__has_corresponding_date() {
        XCTAssertEqual(indexItem.makeProxy().date, indexItem.date)
    }

    func testThat__reading__identifier__does_not_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.identifier
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__indexItem__does_not_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.indexItem
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__person_name__does_not_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.personName
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__date__does_not_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.date
        XCTAssertFalse(proxy.isMaterialized)
    }

    func testThat__reading__person__does_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.person
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__reading__answers__does_materialize_proxy() {
        let proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        _ = proxy.answers
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__date__does_materialize_proxy() {
        var proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.date = Date.distantPast
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__date__does_update_record_date() {
        var proxy = indexItem.makeProxy()

        XCTAssertNotEqual(proxy.date, Date.distantPast)
        proxy.date = Date.distantPast
        XCTAssertEqual(proxy.date, Date.distantPast)
    }

    func testThat__writing__date__does_update_index_date() {
        var proxy = indexItem.makeProxy()

        XCTAssertNotEqual(proxy.indexItem.date, Date.distantPast)
        proxy.date = Date.distantPast
        XCTAssertEqual(proxy.indexItem.date, Date.distantPast)
    }

    func testThat__writing__date__keeps_person_name() {
        var proxy = indexItem.makeProxy()

        let personName = proxy.personName
        proxy.date = Date.distantPast
        XCTAssertEqual(personName, proxy.personName)
    }

    func testThat__writing__person__does_materialize_proxy() {
        var proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.person = Person()
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__writing__person__updates_record_person() {
        var proxy = indexItem.makeProxy()
        let newPerson = Person(name: "Leslie Knope", gender: .female, ageGroup: .adult)

        XCTAssertNotEqual(proxy.person.name, newPerson.name)
        proxy.person = newPerson
        XCTAssertEqual(proxy.person.name, newPerson.name)
    }

    func testThat__writing__person__updates_index_person_name() {
        var proxy = indexItem.makeProxy()

        XCTAssertNotEqual(proxy.indexItem.personName, Person().name)
        proxy.person = Person()
        XCTAssertEqual(proxy.indexItem.personName, Person().name)
    }

    func testThat__writing__answers__does_materialize_proxy() {
        var proxy = indexItem.makeProxy()

        XCTAssertFalse(proxy.isMaterialized)
        proxy.answers = Answers()
        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__proxy_initialized_with_record__is_materialized() {
        let record = Record()
        let proxy = Proxy(indexItem: indexItem, record: record)

        XCTAssertTrue(proxy.isMaterialized)
    }

    func testThat__proxy_initialized_with_record__is_materialized_with_the_same_record() {
        let record = Record()
        let proxy = Proxy(indexItem: indexItem, record: record)

        XCTAssertMemberwiseEqual(proxy.person, record.person)
        XCTAssertEqual(proxy.date, record.date)
        XCTAssertEqual(proxy.answers, record.answers)
    }

    func testThat__materialized_proxy__ignores_index_item_date() {
        let record = Record()
        let proxy = Proxy(indexItem: indexItem, materialize: { _ in record })

        _ = proxy.answers
        XCTAssertNotEqual(proxy.date, indexItem.date)
        XCTAssertEqual(proxy.date, record.date)
    }

    func testThat__materialized_proxy__ignores_index_item_person_name() {
        let record = Record()
        let proxy = Proxy(indexItem: indexItem, materialize: { _ in record })

        _ = proxy.answers
        XCTAssertNotEqual(proxy.personName, indexItem.personName)
        XCTAssertEqual(proxy.personName, record.personName)
    }

    func testThat__proxy_description_contains_person_name() {
        XCTAssertTrue(indexItem.makeProxy().description.contains(indexItem.personName))
    }
}
