import Foundation

// TODO: test that proxy serialization does not materialize proxy

struct JSONTestRecordProxySerialization {
    let dateFormatter: DateFormatter

    init(dateFormatter: DateFormatter = .serialization) {
        self.dateFormatter = dateFormatter
    }
}


extension JSONTestRecordProxySerialization {
    func encode(_ proxy: JSONTestRecordProxy) -> [String:String] {
        return [
            Key.name: proxy.personName,
            Key.fileName: proxy.personName,
            Key.directory: proxy.directory,
            Key.date: dateFormatter.string(from: proxy.date)
        ]
    }


    func decode(_ value: Any?) -> JSONTestRecordProxy? {
        guard let json = value as? [String:String],
            let name  = json[Key.name],
            let fileName = json[Key.fileName],
            let directory = json[Key.directory],
            let date = dateFormatter.date(from: json[Key.date] ?? "") else {
                return nil
        }

        let proxy = JSONTestRecordProxy(fileName: fileName, directory: directory)
        proxy.personName = name
        proxy.date = date

        return proxy
    }
}


extension JSONTestRecordProxySerialization {
    enum Key {
        static let name = "name"
        static let fileName = "fileName"
        static let directory = "directory"
        static let date = "date"
    }
}
