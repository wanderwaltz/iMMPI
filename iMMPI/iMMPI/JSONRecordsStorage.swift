import Foundation

let kJSONRecordStorageDirectoryDefault = "JSONRecords"
let kJSONRecordStorageDirectoryTrash = "JSONRecords-Trash"

final class JSONRecordsStorage {
    var trashStorage: JSONRecordsStorage?

    init(directoryName: String = kJSONRecordStorageDirectoryDefault,
         indexSerialization: JSONRecordIndexSerialization = JSONRecordIndexSerialization(),
         recordSerialization: JSONRecordSerialization = JSONRecordSerialization(),
         fileManager: FileManager = .default) throws {
        let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let storedRecordsUrl = directories.last!.appendingPathComponent(directoryName)

        try createDirectoryIfNeeded(at: storedRecordsUrl, with: fileManager)

        self.fileManager = fileManager
        self.indexSerialization = indexSerialization
        self.recordSerialization = recordSerialization
        self.storageDirectoryName = directoryName
        self.storedRecordsUrl = storedRecordsUrl
    }

    fileprivate let fileManager: FileManager

    fileprivate let indexSerialization: JSONRecordIndexSerialization
    fileprivate let recordSerialization: JSONRecordSerialization

    fileprivate let storageDirectoryName: String
    fileprivate let storedRecordsUrl: URL
    fileprivate let dateFormatter = DateFormatter.medium

    fileprivate var elements = [Element]()
    fileprivate var loadedFileNames = Set<String>()
}


extension JSONRecordsStorage: RecordStorage {
    var all: [RecordProtocol] {
        return elements.flatMap({ $0.record })
    }


    func add(_ record: RecordProtocol) throws {
        let element = Element()
        element.record = record
        elements.append(element)
        try store(element)
    }


    func update(_ record: RecordProtocol) throws {
        try store(element(for: record))
    }


    func remove(_ record: RecordProtocol) throws {
        try remove(element(for: record))
    }


    func contains(_ record: RecordProtocol) -> Bool {
        return element(for: record) != nil
    }


    func load() throws {
        try loadIndex()

        let subpaths = try fileManager.contentsOfDirectory(
            at: storedRecordsUrl,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants]
        )

        for url in subpaths {
            let fileName = url.lastPathComponent
            if url.pathExtension == kJSONPathExtension && false == loadedFileNames.contains(fileName) {
                let data = try Data(contentsOf: url)

                guard let record = recordSerialization.decode(data) else {
                    continue
                }

                let element = Element()
                element.record = JSONRecordProxy(record: record, fileName: fileName, directory: storageDirectoryName)
                element.fileName = fileName

                loadedFileNames.insert(fileName)
                elements.append(element)
            }
        }

        try saveIndex()

        NSLog("\(loadedFileNames.count) files loaded")
    }
}


extension JSONRecordsStorage {
    var proxies: [JSONRecordProxy] {
        return elements.flatMap({ $0.record as? JSONRecordProxy })
    }


    var indexUrl: URL {
        return storedRecordsUrl
            .appendingPathComponent(kIndexFileName)
            .appendingPathExtension(kJSONPathExtension)
    }


    fileprivate func loadIndex() throws {
        let indexUrl = self.indexUrl

        guard fileManager.fileExists(atPath: indexUrl.path) else {
            return
        }

        let indexData = try Data(contentsOf: indexUrl)
        let proxies = indexSerialization.decode(indexData)

        for proxy in proxies {
            let proxiedFileUrl = storedRecordsUrl.appendingPathComponent(proxy.fileName)

            guard fileManager.fileExists(atPath: proxiedFileUrl.path)
                && false == loadedFileNames.contains(proxy.fileName) else {
                    continue
            }

            if false == loadedFileNames.contains(proxy.fileName) {
                let element = Element()
                element.record = proxy
                element.fileName = proxy.fileName

                loadedFileNames.insert(proxy.fileName)
                elements.append(element)
            }
        }
    }


    fileprivate func saveIndex() throws {
        guard let indexData = indexSerialization.encode(proxies) else {
            return
        }

        try indexData.write(to: indexUrl)
    }
}


extension JSONRecordsStorage {
    fileprivate func remove(_ element: Element?) throws {
        guard let element = element else {
            return
        }

        guard let fileName = element.fileName, false == fileName.isEmpty else {
            return
        }

        if let record = element.record {
            try trashStorage?.add(record)
        }

        try removeRecordFile(named: fileName)
        elements = elements.filter({ $0 !== element })
        try saveIndex()
    }


    fileprivate func removeRecordFile(named fileName: String) throws {
        let url = storedRecordsUrl.appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)

            loadedFileNames.remove(fileName)
        }
    }


    fileprivate func store(_ element: Element?) throws {
        guard let element = element else {
            return
        }

        guard let record = element.record, let data = recordSerialization.encode(record) else {
            return
        }

        let existingFileName = element.fileName
        let suggestedFileName = fileName(for: record)

        if existingFileName != nil && suggestedFileName != existingFileName {
            // Remove the file containing the old version
            // since the new suggested file name has changed
            try removeRecordFile(named: existingFileName!)
        }

        element.fileName = suggestedFileName
        loadedFileNames.insert(suggestedFileName)

        let url = storedRecordsUrl.appendingPathComponent(suggestedFileName)
        try data.write(to: url, options: .atomic)
    }


    fileprivate func fileName(for record: RecordProtocol) -> String {
        let illegalFileNameCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>$&@")
        let candidate = "\(record.personName) - \(dateFormatter.string(from: record.date))"
            .components(separatedBy: illegalFileNameCharacters).joined()

        var fileName = candidate.appending(".\(kJSONPathExtension)")
        var attempts = 0

        while false == fileNameIsAvailable(fileName) {
            attempts += 1
            fileName = candidate.appendingFormat(" %ld.%@", attempts, kJSONPathExtension)
        }

        return fileName
    }


    fileprivate func fileNameIsAvailable(_ fileName: String) -> Bool {
        let url = storedRecordsUrl.appendingPathComponent(fileName)
        return false == fileManager.fileExists(atPath: url.path)
    }


    fileprivate func element(for record: RecordProtocol) -> Element? {
        return elements.first(where: { $0.record === record })
    }
}



extension JSONRecordsStorage {
    fileprivate final class Element: NSObject {
        var record: RecordProtocol?
        var fileName: String?
    }
}



fileprivate let kJSONPathExtension = "json"
fileprivate let kIndexFileName = "index"


fileprivate func createDirectoryIfNeeded(at url: URL, with fileManager: FileManager) throws {
    if false == fileManager.fileExists(atPath: url.path) {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
