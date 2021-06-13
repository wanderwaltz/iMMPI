import Foundation

/// Encapsulates a persistent storage for objects conforming to RecordProtocol.
public protocol RecordStorage: AnyObject {
    /// Return all test records currently loaded.
    var all: [RecordProtocol] { get }


    /// Add a new test record into the storage.
    ///
    /// The behavior is undefined if the record already exists. Classes adopting 
    /// this protocol may choose to add the same record twice or to update 
    /// the existing one in this case.
    ///
    /// - Parameter record: a `RecordProtocol` object to be added to the storage.
    func add(_ record: RecordProtocol) throws


    /// Update the existing record from the storage.
    ///
    /// If the record does not yet exist in storage, this method should throw an error.
    ///
    /// - Param record: a `RecordProtocol` object to be updated in the persistent storage.
    func update(_ record: RecordProtocol) throws


    /// Remove the existing record from the storage.
    ///
    /// If the record does not yet exist in storage, this method should do nothing.
    ///
    /// - Parameter record: a `RecordProtocol` object to be removed from the persistent storage.
    func remove(_ record: RecordProtocol) throws


    /// Check whether the provided RecordProtocol object does exist in the storage.
    ///
    /// - Parameter record: a `RecordProtocol` object to be searched within storage.
    /// - Returns: `true` if the record does exist in storage, `false` otherwise.
    func contains(_ record: RecordProtocol) -> Bool


    /// Load all `RecordProtocol` objects stored in the persistent storage.
    func load() throws
}


extension RecordStorage {
    public var isEmpty: Bool {
        return all.isEmpty
    }
}
