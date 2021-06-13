import Foundation

public final class RecordProxy<IndexItem: RecordIndexItem> {
    public private(set) var indexItem: IndexItem
    private let materialize: (IndexItem) -> Record
    private var _record: Record?

    public init(
        indexItem: IndexItem,
        materialize: @escaping (_ indexItem: IndexItem) -> Record
    ) {
        self.indexItem = indexItem
        self.materialize = materialize
    }
}


extension RecordProxy {
    public var isMaterialized: Bool {
        return _record != nil
    }

    public convenience init(indexItem: IndexItem, record: Record) {
        self.init(indexItem: indexItem, materialize: { _ in record })
        self._record = record
    }
}


extension RecordProxy: CustomStringConvertible {
    public var description: String {
        return "RecordProxy: \(personName), (\(date))"
    }
}


extension RecordProxy: RecordProtocol {
    public var person: Person {
        get { record.person }
        set {
            record.person = newValue
            indexItem = indexItem.settingPersonName(newValue.name)
        }
    }

    public var answers: Answers {
        get { record.answers }
        set { record.answers = newValue }
    }

    public var personName: String {
        if let record = _record {
            return record.personName
        }
        else {
            return indexItem.personName
        }
    }

    public var date: Date {
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
    private var record: RecordProtocol {
        if _record == nil {
            NSLog("Proxy loading record for \(personName)")
            _record = materialize(indexItem)
        }

        return _record!
    }
}
