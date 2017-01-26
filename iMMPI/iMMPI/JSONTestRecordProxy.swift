import Foundation

final class JSONTestRecordProxy: NSObject {
    let fileName: String
    let directory: String

    let serialization = JSONTestRecordSerialization()

    init(fileName: String, directory: String) {
        self.fileName = fileName
        self.directory = directory
    }

    fileprivate var _record: TestRecordProtocol?
    fileprivate var _personName = ""
    fileprivate var _date: Date?
}


extension JSONTestRecordProxy {
    override var description: String {
        return "\(super.description): \(personName), (\(date))"
    }


    convenience init(record: TestRecordProtocol, fileName: String, directory: String) {
        self.init(fileName: fileName, directory: directory)
        self._record = record
    }
}


extension JSONTestRecordProxy: TestRecordProtocol {
    var person: PersonProtocol {
        get {
            return record.person
        }

        set {
            record.person = newValue
        }
    }


    var testAnswers: TestAnswers {
        get {
            return record.testAnswers
        }

        set {
            record.testAnswers = newValue
        }
    }


    var personName: String {
        get {
            if let record = _record {
                return record.personName
            }
            else {
                return _personName
            }
        }

        set {
            _personName = newValue
        }
    }


    var date: Date {
        get {
            if let record = _record {
                return record.date
            }
            else if let date = _date {
                return date
            }
            else {
                return record.date
            }
        }


        set {
            _date = newValue
        }
    }
}


extension JSONTestRecordProxy {
    fileprivate var record: TestRecordProtocol {
        if _record == nil {
            loadRecord()
        }

        return _record!
    }


    fileprivate func loadRecord() {
        var loadedRecord: TestRecordProtocol = TestRecord()

        defer {
            _record = loadedRecord
        }

        NSLog("Proxy loading record for \(personName)")

        guard let documentsUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Failed locating documents directory")
            return
        }


        let recordsDirectory = documentsUrl.appendingPathComponent(directory)
        let recordPath = recordsDirectory.appendingPathComponent(fileName)

        let data: Data

        do {
            try data = Data(contentsOf: recordPath)
        }
        catch let error {
            assertionFailure("Error reading data: \(error)")
            return
        }

        loadedRecord = serialization.decode(data) ?? loadedRecord
    }
}
