import Foundation

// TODO: test that proxy serialization does not materialize proxy

struct JSONRecordProxySerialization {
    let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter = .serialization) {
        self.dateFormatter = dateFormatter
    }
}


extension JSONRecordProxySerialization {
    func encode(_ proxy: JSONRecordProxy) -> [String:String] {
        return [
            Key.name: proxy.personName,
            Key.fileName: proxy.fileName,
            Key.directory: proxy.directory,
            Key.date: dateFormatter.string(from: proxy.date)
        ]
    }


    func decode(_ value: Any?) -> JSONRecordProxy? {
        guard let json = value as? [String:String],
            let name  = json[Key.name],
            let fileName = json[Key.fileName],
            let directory = json[Key.directory],
            let date = dateFormatter.date(from: json[Key.date] ?? "") else {
                return nil
        }

        let proxy = JSONRecordProxy(fileName: fileName, directory: directory)
        proxy.personName = name
        proxy.date = date

        return proxy
    }
}


extension JSONRecordProxySerialization {
    enum Key {
        static let name = "name"
        static let fileName = "fileName"
        static let directory = "directory"
        static let date = "date"
    }
}
