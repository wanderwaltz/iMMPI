import Foundation
import DataModel

public struct JSONRecordProxySerialization {
    let indexItemSerialization: JSONIndexItemSerialization

    public init(indexItemSerialization: JSONIndexItemSerialization = .init()) {
        self.indexItemSerialization = indexItemSerialization
    }
}

extension JSONRecordProxySerialization {
    public func encode(_ proxy: JSONRecordProxy) -> [String:String] {
        return indexItemSerialization.encode(proxy.indexItem)
    }

    public func decode(_ value: Any?) -> JSONRecordProxy? {
        return indexItemSerialization.decode(value).map({ indexItem in
            JSONRecordProxy(indexItem: indexItem, materialize: JSONIndexItem.materializeRecord)
        })
    }
}
