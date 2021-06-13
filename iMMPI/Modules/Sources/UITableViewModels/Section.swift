import Foundation

public struct Section<Item> {
    public let title: String
    public let items: [Item]

    public init(title: String, items: [Item]) {
        self.title = title
        self.items = items
    }
}


extension Section {
    public func map<T>(_ mapping: (Item) -> T) -> Section<T> {
        return Section<T>(title: title, items: items.map(mapping))
    }
}
