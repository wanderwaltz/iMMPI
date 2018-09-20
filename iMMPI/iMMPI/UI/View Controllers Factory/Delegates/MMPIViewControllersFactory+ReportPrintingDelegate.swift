import Foundation

extension MMPIViewControllersFactory {
    final class ReportPrintingDelegate {}
}


extension MMPIViewControllersFactory.ReportPrintingDelegate: AnalysisReportsListViewControllerDelegate {
    func analysisReportsList(_ controller: AnalysisReportsListViewController, didSelectReport html: Html) {
        controller.router?.displayPrintOptions(for: html, sender: controller)
    }
}
