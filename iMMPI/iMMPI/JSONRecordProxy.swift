import Foundation

final class JSONRecordProxy {
    let fileName: String
    let directory: String

    let serialization = JSONRecordSerialization()

    init(fileName: String, directory: String) {
        self.fileName = fileName
        self.directory = directory
    }

    fileprivate var _record: RecordProtocol?
    fileprivate var _personName = ""
    fileprivate var _date: Date?
}


extension JSONRecordProxy: CustomStringConvertible {
    var description: String {
        return "JSONRecordProxy: \(personName), (\(date))"
    }
}


extension JSONRecordProxy {
    convenience init(record: RecordProtocol, fileName: String, directory: String) {
        self.init(fileName: fileName, directory: directory)
        self._record = record
    }
}


extension JSONRecordProxy: RecordProtocol {
    var person: Person {
        get {
            return record.person
        }

        set {
            record.person = newValue
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


extension JSONRecordProxy {
    fileprivate var record: RecordProtocol {
        if _record == nil {
            loadRecord()
        }

        return _record!
    }


    fileprivate func loadRecord() {
        var loadedRecord: RecordProtocol = Record()

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
