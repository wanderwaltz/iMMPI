import Foundation

public final class JSONRecordIndexSerialization {
    let proxy: JSONRecordProxySerialization

    public init(proxy: JSONRecordProxySerialization = .init()) {
        self.proxy = proxy
    }
}

extension JSONRecordIndexSerialization {
    public func encode(_ proxies: [JSONRecordProxy]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: proxies.map(proxy.encode), options: .prettyPrinted)
    }

    public func decode(_ data: Data?) -> [JSONRecordProxy] {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:String]] else {
                return []
        }

        return json.compactMap(proxy.decode)
    }
}
