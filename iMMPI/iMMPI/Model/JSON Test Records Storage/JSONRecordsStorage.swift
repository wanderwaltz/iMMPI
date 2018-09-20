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
    var all: [Record] {
        return elements.compactMap({ $0.value.record })
    }

    func store(_ record: Record) throws {
        let identifier = record.identifier
        let element = self.element(for: identifier) ?? Element()
        element.record = record
        elements[identifier] = element
        try store(element)
        try saveIndex()
    }

    func removeRecord(with identifier: RecordIdentifier) throws {
        try remove(element(for: identifier))
    }

    func load() throws {
        try loadIndex()

        let subpaths = try fileManager.contentsOfDirectory(
            at: storedRecordsUrl,
            includingPropertiesForKeys: [.addedToDirectoryDateKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants]
        )
        .sorted(by: { url1, url2 in
            let date1 = ((try? url1.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate) ?? .distantPast
            let date2 = ((try? url2.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate) ?? .distantPast

            return date1 < date2
        })

        for url in subpaths {
            let fileName = url.lastPathComponent
            if url.pathExtension == kJSONPathExtension && false == loadedFileNames.contains(fileName) {
                let data = try Data(contentsOf: url)

                guard let record = recordSerialization.decode(data) else {
                    continue
                }

                let element = Element()

                element.record = record
                element.fileName = fileName

                let oldFileName = elements[record.identifier]?.fileName

                loadedFileNames.insert(fileName)
                elements[record.identifier] = element

                if let oldFileName = oldFileName {
                    try removeRecordFile(named: oldFileName)
                }
            }
        }

        try saveIndex()

        NSLog("\(loadedFileNames.count) files loaded")
    }
}


extension JSONRecordsStorage {
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

        let indexItemsSortedByDate = indexItems.map({ item -> (item: JSONIndexItem, url: URL) in
            let url = storedRecordsUrl.appendingPathComponent(item.fileName)
            return (item: item, url: url)
        })
        .filter({ fileManager.fileExists(atPath: $0.url.path) })
        .sorted(by: { item1, item2 in
            let date1 = ((try? item1.url.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate) ?? .distantPast
            let date2 = ((try? item2.url.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate) ?? .distantPast

            return date1 < date2
        })
        .map({ $0.item })

        for item in indexItemsSortedByDate {
            guard false == loadedFileNames.contains(item.fileName) else {
                continue
            }

            if false == loadedFileNames.contains(item.fileName) {
                let element = Element()
                let proxy = Record(
                    indexItem: item.indexItem,
                    materialize: JSONIndexItem.materializeRecord(item)
                )

                element.record = proxy
                element.fileName = item.fileName

                let oldFileName = elements[proxy.identifier]?.fileName

                loadedFileNames.insert(item.fileName)
                elements[proxy.identifier] = element

                if let oldFileName = oldFileName {
                    try removeRecordFile(named: oldFileName)
                }
            }
        }
    }


    private func saveIndex() throws {
        let items = elements.values.compactMap({ element -> JSONIndexItem? in
            guard let record = element.record else {
                return nil
            }

            let fileName = self.fileName(for: record)
            let indexItem = record.indexItem

            return JSONIndexItem(
                personName: indexItem.personName,
                date: indexItem.date,
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


    private func fileName(for record: Record) -> String {
        let illegalFileNameCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>$&@")
        let indexItem = record.indexItem
        let candidate = "\(indexItem.personName) - \(dateFormatter.string(from: indexItem.date))"
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
        var record: Record?
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
