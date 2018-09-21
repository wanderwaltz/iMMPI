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

    let screenDescriptorSerialization: ScreenDescriptorSerialization

    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController {
        let controller = descriptor.makeViewController(with: self)
        controller.restorationIdentifier = descriptor.restorationIdentifier

        // UINavigationController won't restore its children if a custom restoration class is set.
        if false == controller is UINavigationController {
            controller.restorationClass = MMPIViewControllerRestoration.self
        }

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


final class MMPIViewControllerRestoration: UIViewControllerRestoration {
    static var sharedViewControllerFactory: ViewControllersFactory?

    static func viewController(withRestorationIdentifierPath identifierComponents: [String],
                               coder: NSCoder) -> UIViewController? {
        guard let factory = sharedViewControllerFactory else {
            return nil
        }

        guard let descriptor = factory.screenDescriptorSerialization.decode(identifierComponents.last) else {
            return nil
        }

        return factory.makeViewController(for: descriptor)
    }
}
