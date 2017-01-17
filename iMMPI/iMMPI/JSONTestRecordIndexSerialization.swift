import Foundation

// TODO: drop @objc requirements when possible
final class JSONTestRecordIndexSerialization: NSObject {
    let proxy: JSONTestRecordProxySerialization

    init(proxy: JSONTestRecordProxySerialization = JSONTestRecordProxySerialization()) {
        self.proxy = proxy
    }
}


extension JSONTestRecordIndexSerialization {
    func encode(_ proxies: [JSONTestRecordProxy]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: proxies.map(proxy.encode), options: .prettyPrinted)
    }


    func decode(_ data: Data?) -> [JSONTestRecordProxy] {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:String]] else {
                return []
        }

        return json.flatMap(proxy.decode)
    }
}
