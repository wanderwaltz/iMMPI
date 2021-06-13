import Foundation
import DataModel

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
        let record = Record()
        
        record.date = indexItem.date
        record.person = Person(
            name: indexItem.personName,
            gender: .male,
            ageGroup: .adult
        )

        return record
    }
}
