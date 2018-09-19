import Foundation

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


extension JSONIndexItem {
    var indexItem: RecordIndexItem {
        return RecordIndexItem(
            personName: personName,
            date: date
        )
    }
}


extension JSONIndexItem {
    init(record: Record, fileName: String, directory: JSONRecordsStorageDirectory) {
        self.init(
            personName: record.indexItem.personName,
            date: record.date,
            fileName: fileName,
            directory: directory
        )
    }
}


extension JSONIndexItem {
    static let serialization = JSONRecordSerialization()

    static func materializeRecord(_ indexItem: JSONIndexItem) -> () -> Record {
        return {
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
}
