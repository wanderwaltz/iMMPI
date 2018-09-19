import Foundation

// MARK: - Record

/// Encapsulates information about a single test session.
///
/// Test session consists of a person taking test, their answers for the test
/// and the date of the test session.
///
/// Record is implemented as a struct wrapper over a private RecordImpl with
/// copy on write semantics. This allows using a lazy loaded impl for cases
/// when loading a lot of records in bulk would negatively impact performance.
struct Record {
    private init(_ impl: RecordImpl) {
        self.impl = impl
    }

    private var impl: RecordImpl
}


// MARK: Record initializers
extension Record {
    init(person: Person = .init(), answers: Answers = .init(), date: Date = .init()) {
        self.init(
            MaterialRecordImpl(
                person: person,
                answers: answers,
                date: date
            )
        )
    }

    init(indexItem: RecordIndexItem, materialize: @escaping () -> Record) {
        self.init(
            LazyLoadedRecordImpl(
                indexItem: indexItem, materialize: {
                    MaterialRecordImpl(materialize().impl)
                }
            )
        )
    }
}


// MARK: CustomStringConvertible
extension Record: CustomStringConvertible {
    var description: String {
        return "RecordProxy: \(indexItem.personName), (\(indexItem.date))"
    }
}


// MARK: immaterial record info
extension Record {
    var identifier: RecordIdentifier {
        return impl.identifier
    }

    var indexItem: RecordIndexItem {
        return impl.indexItem
    }

    var isMaterialized: Bool {
        return impl.isMaterialized
    }
}


// MARK: material record info
extension Record {
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

    var date: Date {
        get {
            return impl.date
        }

        set {
            mutateImpl(with: { $0.date = newValue })
        }
    }
}


// MARK: copy on write semantics
extension Record {
    private mutating func mutateImpl(with block: (inout RecordImpl) -> Void) {
        if false == isKnownUniquelyReferenced(&impl) {
            impl = MaterialRecordImpl(impl)
        }

        block(&impl)
    }
}


// MARK: - RecordImpl

// Glossary:
// - 'Material' record - a record with all its data loaded. May contain a significant amount of data
//                       unsuitable for loading in bulk. For example, loading 300 material records
//                       took more than two seconds on iPad 3, which is a significant delay
//                       when loading the app.
//
// - 'Immaterial' record - a minimal record info suitable for displaying on screen in a list. We always
//                         assume that there is a way to 'materialize' an immaterial record, i.e. load
//                         its complete data when needed.

/// Immaterial part of the Record contains minimal info available without materializing the record.
private protocol ImmaterialRecordInfo {
    var identifier: RecordIdentifier { get }
    var indexItem: RecordIndexItem { get }
    var isMaterialized: Bool { get }
}

/// Material part of the Record contains all record's data, which may be relatively large.
private protocol MaterialRecordInfo {
    var person: Person { get set }
    var answers: Answers { get set }
    var date: Date { get set }
}

/// Full Record implementation combines both material and immaterial info into a single object.
private class RecordImpl: ImmaterialRecordInfo, MaterialRecordInfo {
    // MARK: ImmaterialRecordInfo
    var identifier: RecordIdentifier {
        fatalError("override in subclasses")
    }

    var indexItem: RecordIndexItem {
        fatalError("override in subclasses")
    }

    var isMaterialized: Bool {
        fatalError("override in subclasses")
    }


    // MARK: MaterialRecordInfo
    var person: Person {
        get {
            fatalError("override in subclasses")
        }

        set {
            fatalError("override in subclasses")
        }
    }

    var answers: Answers {
        get {
            fatalError("override in subclasses")
        }

        set {
            fatalError("override in subclasses")
        }
    }

    var date: Date {
        get {
            fatalError("override in subclasses")
        }

        set {
            fatalError("override in subclasses")
        }
    }
}



// MARK: - MaterialRecordImpl
/// Material record implementation for records with fully loaded info
private final class MaterialRecordImpl: RecordImpl {
    init(person: Person, answers: Answers, date: Date) {
        _person = person
        _answers = answers
        _date = date
    }

    convenience init(_ other: RecordImpl) {
        self.init(
            person: other.person,
            answers: other.answers,
            date: other.date
        )
    }

    private var _person: Person
    private var _answers: Answers
    private var _date: Date


    // MARK: ImmaterialRecordInfo
    override var identifier: RecordIdentifier {
        return RecordIdentifier(
            personIdentifier: _person.identifier,
            date: _date
        )
    }

    override var indexItem: RecordIndexItem {
        return RecordIndexItem(
            personName: _person.name,
            date: _date
        )
    }

    override var isMaterialized: Bool {
        return true
    }


    // MARK: MaterialRecordInfo
    override var person: Person {
        get {
            return _person
        }

        set {
            _person = newValue
        }
    }

    override var answers: Answers {
        get {
            return _answers
        }

        set {
            _answers = newValue
        }
    }

    override var date: Date {
        get {
            return _date
        }

        set {
            _date = newValue
        }
    }
}



// MARK: - LazyLoadedRecordImpl
private final class LazyLoadedRecordImpl: RecordImpl {
    init(indexItem: RecordIndexItem, materialize: @escaping () -> MaterialRecordImpl) {
        _indexItem = indexItem
        _materialize = materialize
    }

    private let _materialize: () -> MaterialRecordImpl
    private var _materialRecord: MaterialRecordImpl?
    private var _indexItem: RecordIndexItem

    // MARK: ImmaterialRecordInfo
    override var identifier: RecordIdentifier {
        return RecordIdentifier(
            personIdentifier: PersonIdentifier(
                name: indexItem.personName
            ),
            date: indexItem.date
        )
    }

    override var indexItem: RecordIndexItem {
        return _indexItem
    }

    override var isMaterialized: Bool {
        return _materialRecord != nil
    }

    var materialRecord: MaterialRecordImpl {
        materializeRecord()
        return _materialRecord!
    }

    func materializeRecord() {
        if _materialRecord == nil {
            NSLog("Materializing record for \(indexItem)")
            _materialRecord = _materialize()
        }
    }

    func mutateRecord(with block: (MaterialRecordImpl) -> Void) {
        materializeRecord()
        block(_materialRecord!)
    }


    // MARK: MaterialRecordInfo
    override var person: Person {
        get {
            return materialRecord.person
        }

        set {
            mutateRecord(with: { $0.person = newValue })
            _indexItem.personName = newValue.name
        }
    }

    override var answers: Answers {
        get {
            return materialRecord.answers
        }

        set {
            mutateRecord(with: { $0.answers = newValue })
        }
    }

    override var date: Date {
        get {
            return _materialRecord?.date ?? indexItem.date
        }

        set {
            mutateRecord(with: { $0.date = newValue })
            _indexItem.date = newValue
        }
    }
}
