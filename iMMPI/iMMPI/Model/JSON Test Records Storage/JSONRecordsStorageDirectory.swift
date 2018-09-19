import Foundation

struct JSONRecordsStorageDirectory: Hashable {
    let name: String
}


extension JSONRecordsStorageDirectory {
    var url: URL {
        return baseDirectory.appendingPathComponent(name)
    }
}


extension JSONRecordsStorageDirectory {
    static let `default` = JSONRecordsStorageDirectory(name: "JSONRecords")
    static let trash = JSONRecordsStorageDirectory(name: "JSONRecords-Trash")
}


private var baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
