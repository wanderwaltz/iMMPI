import Foundation
@testable import iMMPI

struct StubRecordIndexItem: RecordIndexItem {
    let personName: String
    let date: Date

    func settingPersonName(_ newName: String) -> StubRecordIndexItem {
        return StubRecordIndexItem(
            personName: newName,
            date: date
        )
    }


    func settingDate(_ newDate: Date) -> StubRecordIndexItem {
        return StubRecordIndexItem(
            personName: personName,
            date: newDate
        )
    }
}


extension StubRecordIndexItem {
    func makeProxy() -> RecordProxy<StubRecordIndexItem> {
        return RecordProxy(indexItem: self, materialize: StubRecordIndexItem.materializeRecord)
    }

    static func materializeRecord(_ indexItem: StubRecordIndexItem) -> Record {
        var record = Record()
        
        record.date = indexItem.date
        record.person = Person(
            name: indexItem.personName,
            gender: .male,
            ageGroup: .adult
        )

        return record
    }
}
