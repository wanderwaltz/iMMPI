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

    private var elements = [RecordIdentifier: Element]()
    private var loadedFileNames = Set<String>()
}


extension JSONRecordsStorage: RecordStorage {
    var all: [RecordProtocol] {
        return elements.compactMap({ $0.value.record })
    }

    func store(_ record: RecordProtocol) throws {
        let identifier = record.identifier
        let element = self.element(for: identifier) ?? Element()
        element.record = record
        elements[identifier] = element
        try store(element)
    }

    func removeRecord(with identifier: RecordIdentifier) throws {
        try remove(element(for: identifier))
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
                let proxy = JSONRecordProxy(indexItem: indexItem, record: record)

                element.record = proxy
                element.fileName = fileName

                loadedFileNames.insert(fileName)
                elements[record.identifier] = element
            }
        }

        try saveIndex()

        NSLog("\(loadedFileNames.count) files loaded")
    }
}


extension JSONRecordsStorage {
    var proxies: [JSONRecordProxy] {
        return elements.compactMap({ $0.value.record as? JSONRecordProxy })
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
        let indexItems = indexSerialization.decode(indexData)

        for item in indexItems {
            let proxiedFileUrl = storedRecordsUrl.appendingPathComponent(item.fileName)

            guard fileManager.fileExists(atPath: proxiedFileUrl.path)
                && false == loadedFileNames.contains(item.fileName) else {
                    continue
            }

            if false == loadedFileNames.contains(item.fileName) {
                let element = Element()
                let proxy = RecordProxy(
                    indexItem: item,
                    materialize: JSONIndexItem.materializeRecord
                )

                element.record = proxy
                element.fileName = item.fileName

                loadedFileNames.insert(item.fileName)
                elements[proxy.identifier] = element
            }
        }
    }


    private func saveIndex() throws {
        let items = elements.values.compactMap({ element -> JSONIndexItem? in
            guard let record = element.record else {
                return nil
            }

            let fileName = self.fileName(for: record)

            return JSONIndexItem(
                personName: record.personName,
                date: record.date,
                fileName: fileName,
                directory: directory
            )
        })

        guard let indexData = indexSerialization.encode(items) else {
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
            try trashStorage?.store(record)
        }

        try removeRecordFile(named: fileName)
        elements = elements.filter({ $0.value !== element })
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


    private func element(for identifier: RecordIdentifier) -> Element? {
        return elements[identifier]
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
