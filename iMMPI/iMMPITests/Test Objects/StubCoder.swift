import Foundation

final class StubCoder: NSCoder {
    var encodedObjects: [String: Any] = [:]

    override func encode(_ object: Any?, forKey key: String) {
        encodedObjects[key] = object
    }

    override func decodeObject(forKey key: String) -> Any? {
        return encodedObjects[key]
    }
}
