import Foundation

struct JSONIndexItemSerialization {
    let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter = .serialization) {
        self.dateFormatter = dateFormatter
    }
}


extension JSONIndexItemSerialization {
    func encode(_ item: JSONIndexItem) -> [String:String] {
        return [
            Key.name: item.personName,
            Key.fileName: item.fileName,
            Key.directory: item.directory.name,
            Key.date: dateFormatter.string(from: item.date)
        ]
    }


    func decode(_ value: Any?) -> JSONIndexItem? {
        guard let json = value as? [String:String],
            let name  = json[Key.name],
            let fileName = json[Key.fileName],
            let directory = json[Key.directory],
            let date = dateFormatter.date(from: json[Key.date] ?? "") else {
                return nil
        }

        return JSONIndexItem(
            personName: name,
            date: date,
            fileName: fileName,
            directory: JSONRecordsStorageDirectory(
                name: directory
            )
        )
    }
}


extension JSONIndexItemSerialization {
    enum Key {
        static let name = "name"
        static let fileName = "fileName"
        static let directory = "directory"
        static let date = "date"
    }
}
