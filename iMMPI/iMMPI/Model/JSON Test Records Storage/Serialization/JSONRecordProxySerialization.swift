import Foundation
import DataModel

struct JSONRecordProxySerialization {
    let indexItemSerialization: JSONIndexItemSerialization

    init(indexItemSerialization: JSONIndexItemSerialization = JSONIndexItemSerialization()) {
        self.indexItemSerialization = indexItemSerialization
    }
}


extension JSONRecordProxySerialization {
    func encode(_ proxy: JSONRecordProxy) -> [String:String] {
        return indexItemSerialization.encode(proxy.indexItem)
    }


    func decode(_ value: Any?) -> JSONRecordProxy? {
        return indexItemSerialization.decode(value).map({ indexItem in
            JSONRecordProxy(indexItem: indexItem, materialize: JSONIndexItem.materializeRecord)
        })
    }
}
