import Foundation

struct ScreenDescriptorSerialization {}

extension ScreenDescriptorSerialization {
    func decode(_ rawValue: String?) -> ScreenDescriptor? {
        guard let rawValue = rawValue else {
            return nil
        }

        let components = rawValue.components(separatedBy: "?")

        guard components.count == 1 || components.count == 2 else {
            return nil
        }

        let host = components.first!
        let parameters = parseParameters(components.count == 2 ? components.last! : nil)

        switch host {
        case RestorationIdentifier.allRecords:
            return .allRecords

        case RestorationIdentifier.trash:
            return .trash

        case RestorationIdentifier.editRecordPrefix:
            return parseEditRecord(with: parameters)

        case RestorationIdentifier.detailsForMultipleRecordsPrefix:
            return parseDetailsForMultipleRecords(with: parameters)

        case RestorationIdentifier.analysisPrefix:
            return parseAnalysisForRecords(with: parameters)

        case RestorationIdentifier.answersInputPrefix:
            return parseAnswersInputForRecord(with: parameters)

        case RestorationIdentifier.answersReviewPrefix:
            return parseAnswersReviewForRecord(with: parameters)

        default:
            return nil
        }
    }
}

extension ScreenDescriptorSerialization {
    enum RestorationIdentifier {
        static let allRecords = "all-records"
        static let trash = "trash"

        static func editRecord(with identifier: RecordIdentifier) -> String {
            return singleRecordIdentifier(identifier, prefix: editRecordPrefix)
        }

        static func detailsForMultipleRecords(with identifiers: [RecordIdentifier]) -> String {
            return multipleRecordIdentifiers(identifiers, prefix: detailsForMultipleRecordsPrefix)
        }

        static func analysisForRecords(with identifiers: [RecordIdentifier]) -> String {
            return multipleRecordIdentifiers(identifiers, prefix: analysisPrefix)
        }

        static func answersInputForRecord(with identifier: RecordIdentifier) -> String {
            return singleRecordIdentifier(identifier, prefix: answersInputPrefix)
        }

        static func answersReviewForRecord(with identifier: RecordIdentifier) -> String {
            return singleRecordIdentifier(identifier, prefix: answersReviewPrefix)
        }

        private static func singleRecordIdentifier(_ identifier: RecordIdentifier, prefix: String) -> String {
            return "\(prefix)?\(Parameter.recordIdentifier)=\(identifier.rawValue)"
        }

        private static func multipleRecordIdentifiers(_ identifiers: [RecordIdentifier], prefix: String) -> String {
            return "\(prefix)?\(Parameter.multipleRecordIdentifiers)=\(joined(identifiers))"
        }

        private static func joined(_ identifiers: [RecordIdentifier]) -> String {
            return identifiers
                .map({ $0.rawValue })
                .joined(separator: Parameter.multipleRecordIdentifiersSeparator)
        }

        fileprivate static let editRecordPrefix = "edit-record"
        fileprivate static let detailsForMultipleRecordsPrefix = "records"
        fileprivate static let analysisPrefix = "analysis"
        fileprivate static let answersInputPrefix = "answers-input"
        fileprivate static let answersReviewPrefix = "answers-review"

    }

    private enum Parameter {
        static let recordIdentifier = "id"
        static let multipleRecordIdentifiers = "ids"
        static let multipleRecordIdentifiersSeparator = ","
    }
}


extension ScreenDescriptorSerialization {
    private func parseParameters(_ parameters: String?) -> [String: String] {
        guard let parameters = parameters else {
            return [:]
        }

        let components = parameters.components(separatedBy: "&")
        let pairs = components.compactMap(parseKeyValuePair)

        return Dictionary<String, String>(pairs, uniquingKeysWith: { v1, _ in v1 })
    }

    private func parseKeyValuePair(_ pair: String) -> (key: String, value: String)? {
        let components = pair.components(separatedBy: "=").map({ $0.trimmingCharacters(in: .whitespaces) })

        guard components.count == 2 else {
            return nil
        }

        return (key: components.first!, value: components.last!)
    }

    private func parseEditRecord(with parameters: [String: String]) -> ScreenDescriptor? {
        return withSingleRecordIdentifier(from: parameters) { .editRecord(with: $0) }
    }

    private func parseAnswersInputForRecord(with parameters: [String: String]) -> ScreenDescriptor? {
        return withSingleRecordIdentifier(from: parameters) { .answersInputForRecord(with: $0) }
    }

    private func parseAnswersReviewForRecord(with parameters: [String: String]) -> ScreenDescriptor? {
        return withSingleRecordIdentifier(from: parameters) { .answersReviewForRecord(with: $0) }
    }

    private func withSingleRecordIdentifier(from parameters: [String: String],
                                            makeDescriptor: (RecordIdentifier) -> ScreenDescriptor) -> ScreenDescriptor? {
        guard let rawRecordIdentifier = parameters[Parameter.recordIdentifier] else {
            return nil
        }

        guard let recordIdentifier = RecordIdentifier(rawValue: rawRecordIdentifier) else {
            return nil
        }

        return makeDescriptor(recordIdentifier)
    }

    private func parseDetailsForMultipleRecords(with parameters: [String: String]) -> ScreenDescriptor? {
        return withMultipleRecordIdentifiers(from: parameters) { .detailsForMultipleRecords(with: $0) }
    }

    private func parseAnalysisForRecords(with parameters: [String: String]) -> ScreenDescriptor? {
        return withMultipleRecordIdentifiers(from: parameters) { .analysisForRecords(with: $0) }
    }

    private func withMultipleRecordIdentifiers(from parameters: [String: String],
                                               makeDescriptor: ([RecordIdentifier]) -> ScreenDescriptor) -> ScreenDescriptor? {
        let recordIdentifiers = parseMultipleRecordIdentifiers(with: parameters)

        guard recordIdentifiers.isEmpty == false else {
            return nil
        }

        return makeDescriptor(recordIdentifiers)
    }

    private func parseMultipleRecordIdentifiers(with parameters: [String: String]) -> [RecordIdentifier] {
        guard let joinedRawRecordIdentifiers = parameters[Parameter.multipleRecordIdentifiers] else {
            return []
        }

        let components = joinedRawRecordIdentifiers
            .components(separatedBy: Parameter.multipleRecordIdentifiersSeparator)

        let recordIdentifiers = components.compactMap(RecordIdentifier.init)

        return recordIdentifiers
    }
}
