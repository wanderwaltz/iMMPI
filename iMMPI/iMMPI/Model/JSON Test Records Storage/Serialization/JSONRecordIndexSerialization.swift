import Foundation

final class JSONRecordIndexSerialization {
    let item: JSONIndexItemSerialization

    init(item: JSONIndexItemSerialization = JSONIndexItemSerialization()) {
        self.item = item
    }
}


extension JSONRecordIndexSerialization {
    func encode(_ items: [JSONIndexItem]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: items.map(item.encode), options: .prettyPrinted)
    }


    func decode(_ data: Data?) -> [JSONIndexItem] {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:String]] else {
                return []
        }

        return json.compactMap(item.decode)
    }
}
