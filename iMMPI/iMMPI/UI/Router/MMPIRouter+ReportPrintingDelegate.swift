import Foundation

extension MMPIRouter {
    final class ReportPrintingDelegate {}
}


extension MMPIRouter.ReportPrintingDelegate: AnalysisReportsListViewControllerDelegate {
    func analysisReportsList(_ controller: AnalysisReportsListViewController, didSelectReport html: Html) {
        controller.router?.displayPrintOptions(for: html, sender: controller)
    }
}
