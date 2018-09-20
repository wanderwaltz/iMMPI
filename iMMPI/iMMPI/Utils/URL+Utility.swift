import Foundation

extension URL {
    var mmpiAddedToDirectoryDate: Date {
        let values = try? resourceValues(forKeys: [.addedToDirectoryDateKey])
        let date = values?.addedToDirectoryDate
        return date ?? .distantPast
    }
}
