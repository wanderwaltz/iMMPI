import Foundation

typealias JSONRecordProxy = RecordProxy<JSONIndexItem>

protocol JSONIndexItemProtocol: RecordIndexItem {
    var fileName: String { get }
    var directory: JSONRecordsStorageDirectory { get }
}


struct JSONIndexItem {
    let personName: String
    let date: Date

    let fileName: String
    let directory: JSONRecordsStorageDirectory

    init(personName: String, date: Date, fileName: String, directory: JSONRecordsStorageDirectory) {
        self.personName = personName
        self.date = date
        self.fileName = fileName
        self.directory = directory
    }
}


extension JSONIndexItem: JSONIndexItemProtocol {
    func settingPersonName(_ newName: String) -> JSONIndexItem {
        return JSONIndexItem(
            personName: newName,
            date: date,
            fileName: fileName,
            directory: directory
        )
    }

    func settingDate(_ newDate: Date) -> JSONIndexItem {
        return JSONIndexItem(
            personName: personName,
            date: newDate,
            fileName: fileName,
            directory: directory
        )
    }
}


extension JSONIndexItem {
    init(record: RecordProtocol, fileName: String, directory: JSONRecordsStorageDirectory) {
        self.init(personName: record.personName, date: record.date, fileName: fileName, directory: directory)
    }
}


extension JSONIndexItem {
    static let serialization = JSONRecordSerialization()

    static func materializeRecord(_ indexItem: JSONIndexItem) -> Record {
        let recordPath = indexItem.directory.url.appendingPathComponent(indexItem.fileName)

        let data: Data

        do {
            try data = Data(contentsOf: recordPath)
        }
        catch let error {
            assertionFailure("Error reading data: \(error)")
            return Record()
        }

        return serialization.decode(data) ?? Record()
    }
}


extension RecordProxy where IndexItem: JSONIndexItemProtocol {
    var fileName: String {
        return indexItem.fileName
    }

    var directory: JSONRecordsStorageDirectory {
        return indexItem.directory
    }
}
