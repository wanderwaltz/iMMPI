import Foundation

final class JSONRecordsStorage {
    var trashStorage: JSONRecordsStorage?

    init(directory: JSONRecordsStorageDirectory,
         indexSerialization: JSONRecordIndexSerialization = JSONRecordIndexSerialization(),
         recordSerialization: JSONRecordSerialization = JSONRecordSerialization(),
         fileManager: FileManager = .default) throws {
        try createDirectoryIfNeeded(at: directory.url, with: fileManager)

        self.fileManager = fileManager
        self.indexSerialization = indexSerialization
        self.recordSerialization = recordSerialization
        self.directory = directory
    }

    private let fileManager: FileManager

    private let indexSerialization: JSONRecordIndexSerialization
    private let recordSerialization: JSONRecordSerialization

    private let directory: JSONRecordsStorageDirectory
    private let dateFormatter = DateFormatter.medium

    private var elements = [Element]()
    private var loadedFileNames = Set<String>()
}


extension JSONRecordsStorage: RecordStorage {
    var all: [RecordProtocol] {
        return elements.compactMap({ $0.record })
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
                let indexItem = JSONIndexItem(record: record, fileName: fileName, directory: directory)

                element.record = JSONRecordProxy(indexItem: indexItem, record: record)
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
        return elements.compactMap({ $0.record as? JSONRecordProxy })
    }


    var indexUrl: URL {
        return storedRecordsUrl
            .appendingPathComponent(kIndexFileName)
            .appendingPathExtension(kJSONPathExtension)
    }


    private func loadIndex() throws {
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


    private func saveIndex() throws {
        guard let indexData = indexSerialization.encode(proxies) else {
            return
        }

        try indexData.write(to: indexUrl)
    }
}


extension JSONRecordsStorage {
    private var storedRecordsUrl: URL {
        return directory.url
    }

    private func remove(_ element: Element?) throws {
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


    private func removeRecordFile(named fileName: String) throws {
        let url = storedRecordsUrl.appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)

            loadedFileNames.remove(fileName)
        }
    }


    private func store(_ element: Element?) throws {
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


    private func fileName(for record: RecordProtocol) -> String {
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


    private func fileNameIsAvailable(_ fileName: String) -> Bool {
        let url = storedRecordsUrl.appendingPathComponent(fileName)
        return false == fileManager.fileExists(atPath: url.path)
    }


    private func element(for record: RecordProtocol) -> Element? {
        return elements.first(where: { $0.record === record })
    }
}



extension JSONRecordsStorage {
    private final class Element {
        var record: RecordProtocol?
        var fileName: String?
    }
}



private let kJSONPathExtension = "json"
private let kIndexFileName = "index"


private func createDirectoryIfNeeded(at url: URL, with fileManager: FileManager) throws {
    if false == fileManager.fileExists(atPath: url.path) {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
