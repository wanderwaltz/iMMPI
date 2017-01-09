import Foundation

struct Section<Item> {
    let title: String
    let items: [Item]
}


extension Section {
    func map<T>(_ mapping: (Item) -> T) -> Section<T> {
        return Section<T>(title: title, items: items.map(mapping))
    }
}
