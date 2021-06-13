import Foundation
import DataModel

public typealias JSONRecordProxy = RecordProxy<JSONIndexItem>

public protocol JSONIndexItemProtocol: RecordIndexItem {
    var fileName: String { get }
    var directory: String { get }
}

public struct JSONIndexItem {
    public let personName: String
    public let date: Date

    public let fileName: String
    public let directory: String

    init(
        personName: String,
        date: Date,
        fileName: String,
        directory: String
    ) {
        self.personName = personName
        self.date = date
        self.fileName = fileName
        self.directory = directory
    }
}

extension JSONIndexItem: JSONIndexItemProtocol {
    public func settingPersonName(_ newName: String) -> JSONIndexItem {
        return JSONIndexItem(
            personName: newName,
            date: date,
            fileName: fileName,
            directory: directory
        )
    }

    public func settingDate(_ newDate: Date) -> JSONIndexItem {
        return JSONIndexItem(
            personName: personName,
            date: newDate,
            fileName: fileName,
            directory: directory
        )
    }
}

extension JSONIndexItem {
    init(record: RecordProtocol, fileName: String, directory: String) {
        self.init(personName: record.personName, date: record.date, fileName: fileName, directory: directory)
    }
}

extension JSONIndexItem {
    static let serialization = JSONRecordSerialization()

    static func materializeRecord(_ indexItem: JSONIndexItem) -> Record {
        guard let documentsUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Failed locating documents directory")
            return Record()
        }

        let recordsDirectory = documentsUrl.appendingPathComponent(indexItem.directory)
        let recordPath = recordsDirectory.appendingPathComponent(indexItem.fileName)

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

    var directory: String {
        return indexItem.directory
    }
}
