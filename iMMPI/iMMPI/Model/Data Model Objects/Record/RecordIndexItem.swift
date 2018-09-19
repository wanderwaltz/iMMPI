import Foundation

/// A lightweight struct containing enough info to obtain a `Record` from the store.
struct RecordIndexItem: Hashable {
    var personName: String
    var date: Date
}
