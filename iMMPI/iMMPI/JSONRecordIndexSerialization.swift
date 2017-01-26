import Foundation

// TODO: drop @objc requirements when possible
final class JSONRecordIndexSerialization: NSObject {
    let proxy: JSONRecordProxySerialization

    init(proxy: JSONRecordProxySerialization = JSONRecordProxySerialization()) {
        self.proxy = proxy
    }
}


extension JSONRecordIndexSerialization {
    func encode(_ proxies: [JSONRecordProxy]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: proxies.map(proxy.encode), options: .prettyPrinted)
    }


    func decode(_ data: Data?) -> [JSONRecordProxy] {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:String]] else {
                return []
        }

        return json.flatMap(proxy.decode)
    }
}
