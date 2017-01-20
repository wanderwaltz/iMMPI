import Foundation

extension MenuAction {
    static func print(_ context: AnalysisMenuActionContext) -> MenuAction? {
        guard let router = context.router, UIPrintInteractionController.isPrintingAvailable else {
            return nil
        }

        return MenuAction(title: Strings.print, action: { sender in
            let reportGenerator = HtmlReportGenerator.overall
            let html = reportGenerator.generate(
                for: context.record,
                with: context.analyser
            )

            router.displayPrintOptions(for: html, sender: sender)
        })
    }
}
