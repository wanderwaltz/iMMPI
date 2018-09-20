import UIKit
import MessageUI

struct MMPIViewControllersFactory: ViewControllersFactory {
    let storage: RecordStorage
    let trashStorage: RecordStorage

    let analysisSettings: AnalysisSettings

    let analysisOptionsDelegate: AnalysisOptionsDelegate
    let editingDelegate: EditingDelegate
    let mailComposerDelegate: MailComposerDelegate
    let reportPrintingDelegate: ReportPrintingDelegate

    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController {
        let controller = descriptor.makeViewController(with: self)
        controller.restorationIdentifier = descriptor.restorationIdentifier
        return controller
    }
}


extension MMPIViewControllersFactory: ViewControllerFactoryContext {
    var analysisOptionsViewControllerDelegate: AnalysisOptionsViewControllerDelegate {
        return analysisOptionsDelegate
    }

    var answersInputDelegate: AnswersInputDelegate {
        return editingDelegate
    }

    var editRecordViewControllerDelegate: EditRecordViewControllerDelegate {
        return editingDelegate
    }

    var mailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate {
        return mailComposerDelegate
    }

    var reportListViewControllerDelegate: AnalysisReportsListViewControllerDelegate {
        return reportPrintingDelegate
    }
}
