import Foundation

public struct JSONIndexItemSerialization {
    let dateFormatter: DateFormatter

    public init(dateFormatter: DateFormatter = .serialization) {
        self.dateFormatter = dateFormatter
    }
}

extension JSONIndexItemSerialization {
    public func encode(_ item: JSONIndexItem) -> [String:String] {
        return [
            Key.name: item.personName,
            Key.fileName: item.fileName,
            Key.directory: item.directory,
            Key.date: dateFormatter.string(from: item.date)
        ]
    }

    public func decode(_ value: Any?) -> JSONIndexItem? {
        guard let json = value as? [String:String],
            let name  = json[Key.name],
            let fileName = json[Key.fileName],
            let directory = json[Key.directory],
            let date = dateFormatter.date(from: json[Key.date] ?? "") else {
                return nil
        }

        return JSONIndexItem(personName: name, date: date, fileName: fileName, directory: directory)
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
