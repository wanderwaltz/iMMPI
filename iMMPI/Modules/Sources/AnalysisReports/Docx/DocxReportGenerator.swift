import Foundation
import Analysis
import DocxComposing

public struct DocxReportGenerator {
    public let title: String

    private let dateFormatter: DateFormatter
    private let content: (AnalysisResult, DocxEditing) -> Void

    init(
        title: String,
        dateFormatter: DateFormatter = .medium,
        content: @escaping (AnalysisResult, DocxEditing) -> Void
    ) {
        self.title = title
        self.dateFormatter = dateFormatter
        self.content = content
    }
}

extension DocxReportGenerator: AnalysisReportGenerator {
    public func generate(for result: AnalysisResult) -> URL? {
        let composer = DocxComposer(
            templateBundleName: "ReportTemplate",
            templateBundleBundle: .module,
            fileName: title
        )

        do {
            return try composer.export { edit in
                edit.replaceText("##NAME##", with: result.personName)
                edit.replaceText("##DATE##", with: dateFormatter.string(from: result.date))
                content(result, edit)
            }
        }
        catch {
            print(">>> \(#function) failed: \(error)")
            return nil
        }
    }
}
