import Foundation

final class RecordProxy<IndexItem: RecordIndexItem> {
    fileprivate(set) var indexItem: IndexItem

    init(indexItem: IndexItem, materialize: @escaping (_ indexItem: IndexItem) -> Record) {
        self.indexItem = indexItem
        self.materialize = materialize
    }

    fileprivate let materialize: (IndexItem) -> Record
    fileprivate var _record: Record?
}


extension RecordProxy {
    var isMaterialized: Bool {
        return _record != nil
    }

    convenience init(indexItem: IndexItem, record: Record) {
        self.init(indexItem: indexItem, materialize: Constant.value(record))
        self._record = record
    }
}


extension RecordProxy: CustomStringConvertible {
    var description: String {
        return "RecordProxy: \(personName), (\(date))"
    }
}


extension RecordProxy: RecordProtocol {
    var person: Person {
        get {
            return record.person
        }

        set {
            record.person = newValue
            indexItem = indexItem.settingPersonName(newValue.name)
        }
    }


    var answers: Answers {
        get {
            return record.answers
        }

        set {
            record.answers = newValue
        }
    }


    var personName: String {
        if let record = _record {
            return record.personName
        }
        else {
            return indexItem.personName
        }
    }


    var date: Date {
        get {
            if let record = _record {
                return record.date
            }
            else {
                return indexItem.date
            }
        }

        set {
            record.date = newValue
            indexItem = indexItem.settingDate(newValue)
        }
    }
}


extension RecordProxy {
    fileprivate var record: RecordProtocol {
        if _record == nil {
            NSLog("Proxy loading record for \(personName)")
            _record = materialize(indexItem)
        }

        return _record!
    }
}
