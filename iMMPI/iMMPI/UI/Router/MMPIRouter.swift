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

    fileprivate let analysisOptionsDelegate = AnalysisOptionsDelegate()
    fileprivate let reportPrintingDelegate = ReportPrintingDelegate()
    fileprivate let mailComposerDelegate = MailComposerDelegate()
}


extension MMPIRouter: Router {
    // MARK: record lists
    func displayAllRecords(sender: UIViewController) {
        let controller = viewControllersFactory.makeAllRecordsListViewController()

        if let navigationController = sender as? UINavigationController {
            navigationController.viewControllers = [controller]
        }
        else {
            sender.show(controller, sender: nil)
        }
    }

    func displayTrash(sender: UIViewController) {
        let controller = viewControllersFactory.makeTrashViewController()
        sender.show(controller, sender: nil)
    }


    // MARK: record editing
    func addRecord(basedOn record: Record, sender: UIViewController) {
        edit(record, title: Strings.Screen.newRecord, sender: sender)
    }

    func edit(_ record: Record, sender: UIViewController) {
        edit(record, title: Strings.Screen.editRecord, sender: sender)
    }

    private func edit(_ record: Record, title: String, sender: UIViewController) {
        let controller = viewControllersFactory.makeEditRecordViewController(for: record, title: title)

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
        let controller = viewControllersFactory.makeDetailsViewController(for: identifier)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: sender)
    }

    private func displayDetailsForMultipleRecords(_ identifiers: [RecordIdentifier], sender: UIViewController) {
        let controller = viewControllersFactory.makeDetailsViewController(for: identifiers)
        sender.show(controller, sender: sender)
    }


    // MARK: analysis
    func displayAnalysis(for records: [Record], sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisViewController(for: records)

        let navigationController = UINavigationController(rootViewController: controller)
        sender.showDetailViewController(navigationController, sender: records)
    }

    func displayAnalysisOptions(context: AnalysisMenuActionContext, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnalysisOptionsViewController(context: context)

        controller.delegate = analysisOptionsDelegate

        let navigationController = UINavigationController(rootViewController: controller)
        sender.presentPopover(navigationController, animated: true, completion: nil)
    }

    func displayAnswersReview(for record: Record, sender: UIViewController) {
        let controller = viewControllersFactory.makeAnswersReviewViewController(for: record)
        sender.show(controller, sender: record)
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
            let controller = viewControllersFactory.makeAnalysisReportsListViewController()

            controller.delegate = reportPrintingDelegate
            controller.title = Strings.Screen.print
            controller.result = context.result
            controller.reportGenerators = reportGenerators
            
            sender.show(controller, sender: context)
        }
        else {
            let html = reportGenerators.first!.generate(for: context.result)
            displayPrintOptions(for: html, sender: sender)
        }
    }

    func displayMailComposer(for email: EmailMessage, sender: UIViewController) throws {
        let mailComposer = try viewControllersFactory.makeMailComposerViewController(for: email)
        mailComposer.mailComposeDelegate = mailComposerDelegate
        sender.present(mailComposer, animated: true, completion: nil)
    }
}
