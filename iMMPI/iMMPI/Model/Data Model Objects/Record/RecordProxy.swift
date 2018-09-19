import Foundation

// MARK: - RecordProxy

/// Proxy RecordProtocol implementation with copy on write semantics.
struct RecordProxy<IndexItem: RecordIndexItem> {
    private init(_ impl: RecordProxyImpl<IndexItem>) {
        self.impl = impl
    }

    private var impl: RecordProxyImpl<IndexItem>
}


extension RecordProxy {
    var isMaterialized: Bool {
        return impl.isMaterialized
    }

    init(indexItem: IndexItem, materialize: @escaping (IndexItem) -> Record) {
        self.init(
            RecordProxyImpl(
                indexItem: indexItem,
                materialize: materialize
            )
        )
    }

    init(indexItem: IndexItem, record: Record) {
        self.init(
            RecordProxyImpl(
                indexItem: indexItem,
                record: record
            )
        )
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
            return impl.person
        }

        set {
            mutateImpl(with: { $0.person = newValue })
        }
    }


    var answers: Answers {
        get {
            return impl.answers
        }

        set {
            mutateImpl(with: { $0.answers = newValue })
        }
    }


    var personName: String {
        return impl.personName
    }


    var date: Date {
        get {
            return impl.date
        }

        set {
            mutateImpl(with: { $0.date = newValue })
        }
    }
}


extension RecordProxy {
    private mutating func mutateImpl(with block: (inout RecordProxyImpl<IndexItem>) -> Void) {
        if isKnownUniquelyReferenced(&impl) == false {
            impl = RecordProxyImpl(impl)
        }

        block(&impl)
    }
}


// MARK: - RecordProxyImpl
private final class RecordProxyImpl<IndexItem: RecordIndexItem> {
    private(set) fileprivate var indexItem: IndexItem
    private let materialize: (IndexItem) -> Record
    private var _record: Record?

    init(indexItem: IndexItem, materialize: @escaping (IndexItem) -> Record) {
        self.indexItem = indexItem
        self.materialize = materialize
    }
}


extension RecordProxyImpl {
    convenience init(_ other: RecordProxyImpl) {
        self.init(
            indexItem: other.indexItem,
            materialize: other.materialize
        )
        self._record = other._record
    }

    convenience init(indexItem: IndexItem, record: Record) {
        self.init(indexItem: indexItem, materialize: Constant.value(record))
        self._record = record
    }
}


extension RecordProxyImpl {
    var isMaterialized: Bool {
        return _record != nil
    }

    private func materializeRecord() {
        if _record == nil {
            NSLog("Proxy loading record for \(personName)")
            _record = materialize(indexItem)
        }
    }

    private func mutatingRecord(with block: (inout Record) -> Void) {
        materializeRecord()
        var newRecord = _record!
        block(&newRecord)
        _record = newRecord
    }

    private var record: RecordProtocol {
        materializeRecord()
        return _record!
    }
}


extension RecordProxyImpl: RecordProtocol {
    var person: Person {
        get {
            return record.person
        }

        set {
            mutatingRecord(with: { $0.person = newValue })
            indexItem = indexItem.settingPersonName(newValue.name)
        }
    }


    var answers: Answers {
        get {
            return record.answers
        }

        set {
            mutatingRecord(with: { $0.answers = newValue })
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
            mutatingRecord(with: { $0.date = newValue })
            indexItem = indexItem.settingDate(newValue)
        }
    }
}
