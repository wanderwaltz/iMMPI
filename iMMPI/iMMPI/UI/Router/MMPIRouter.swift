import UIKit
import MessageUI

final class MMPIRouter {
    let storage: RecordStorage

    let viewControllersFactory: RoutedViewControllersFactory

    init(factory: ViewControllersFactory, storage: RecordStorage) {
        self.viewControllersFactory = RoutedViewControllersFactory(base: factory)
        self.storage = storage

        viewControllersFactory.router = self
    }
}


extension MMPIRouter: Router {
    // MARK: record lists
    func displayAllRecords(sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .allRecords)

        if let navigationController = sender as? UINavigationController {
            navigationController.viewControllers = [controller]
        }
        else {
            sender.show(controller, sender: nil)
        }
    }

    func displayTrash(sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .trash)
        sender.show(controller, sender: nil)
    }


    // MARK: record editing
    func addRecord(basedOn record: Record, sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .addRecord(record))

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }

    func editRecord(with identifier: RecordIdentifier, sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .editRecord(with: identifier))

        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .formSheet
        sender.present(navigationController, animated: true, completion: nil)
    }


    // MARK: record details
    func displayDetails(for records: [RecordIdentifier], sender: UIViewController) {
        guard false == records.isEmpty else {
            return
        }

        if records.count == 1 {
            displayDetailsForSingleRecord(records.first!, sender: sender)
        }
        else {
            displayDetailsForMultipleRecords(records, sender: sender)
        }
    }

    private func displayDetailsForSingleRecord(_ identifier: RecordIdentifier, sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .detailsForSingleRecord(with: identifier))

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: sender)
    }

    private func displayDetailsForMultipleRecords(_ identifiers: [RecordIdentifier], sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .detailsForMultipleRecords(with: identifiers))
        sender.show(controller, sender: sender)
    }


    // MARK: analysis
    func displayAnalysis(for identifiers: [RecordIdentifier], sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .analysisForRecords(with: identifiers))

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: sender)
    }

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .analysisOptions(with: context))

        let navigationController = UINavigationController(rootViewController: controller)
        sender.presentPopover(navigationController, animated: true, completion: nil)
    }

    func displayAnswersReview(for identifier: RecordIdentifier, sender: UIViewController) {
        let controller = viewControllersFactory.makeViewController(for: .answersReviewForRecord(with: identifier))
        sender.show(controller, sender: sender)
    }

    func displayPrintOptions(for html: Html, sender: UIViewController) {
        let printController = UIPrintInteractionController.shared
        let formatter = UIMarkupTextPrintFormatter(
            markupText: html.description
        )

        print(html.description)

        printController.printFormatter = formatter
        printController.present(from: sender.view.bounds, in: sender.view, animated: true, completionHandler: nil)
    }

    func selectAnalysisReportForPrinting(context: AnalysisMenuActionContext, sender: UIViewController) {
        let reportGenerators = context.htmlReportGenerators

        guard reportGenerators.count > 0 else {
            return
        }

        if reportGenerators.count > 1 {
            let controller = viewControllersFactory.makeViewController(for: .analysisReportsList(with: context))

            sender.show(controller, sender: context)
        }
        else {
            let html = reportGenerators.first!.generate(for: context.result)
            displayPrintOptions(for: html, sender: sender)
        }
    }

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) {
        let mailComposer = viewControllersFactory.makeViewController(for: .mailComposer(with: email))
        sender.present(mailComposer, animated: true, completion: nil)
    }
}
