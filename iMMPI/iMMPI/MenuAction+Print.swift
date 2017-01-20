import Foundation

extension MenuAction {
    static func print(_ context: AnalysisMenuActionContext) -> MenuAction? {
        guard let router = context.router, UIPrintInteractionController.isPrintingAvailable else {
            return nil
        }

        return MenuAction(title: Strings.Button.print, action: { sender in
            router.selectAnalysisReportForPrinting(context: context, sender: sender)
        })
    }
}
