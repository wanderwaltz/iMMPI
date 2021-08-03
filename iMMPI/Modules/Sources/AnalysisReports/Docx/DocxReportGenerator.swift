import Foundation
import Analysis
import DocxComposing

public struct DocxReportGenerator {
    public let type: String
    private let dateFormatter: DateFormatter
    private let content: (AnalysisResult, DocxEditing) -> Void

    init(
        title: String,
        dateFormatter: DateFormatter = .medium,
        content: @escaping (AnalysisResult, DocxEditing) -> Void
    ) {
        self.type = title
        self.dateFormatter = dateFormatter
        self.content = content
    }
}

extension DocxReportGenerator: AnalysisReportGenerator {
    public struct Report {
        public let url: URL
        public let fileName: String
    }

    public func generate(for result: AnalysisResult) -> Report? {
        let date = dateFormatter.string(from: result.date)
        let fileName = "\(result.personName) — \(date) \(type).docx"

        let composer = DocxComposer(
            templateBundleName: "ReportTemplate",
            templateBundleBundle: .module,
            fileName: fileName
        )

        do {
            let url = try composer.export { edit in
                edit.replaceText("##NAME##", with: result.personName)
                edit.replaceText("##DATE##", with: date)
                content(result, edit)
            }
            return Report(
                url: url,
                fileName: fileName
            )
        }
        catch {
            print(">>> \(#function) failed: \(error)")
            return nil
        }
    }
}
