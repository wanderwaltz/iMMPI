import UIKit

extension ViewControllerMaker {
    static let allRecords = ViewControllerMaker({ context in
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.records
        controller.viewModel = context.storage.makeViewModel()

        attachAddRecordButton(to: controller)
        attachTrashButton(to: controller)

        return controller
    })

    static let trash = ViewControllerMaker({ context in
        let controller = RecordsListViewController(style: .plain)

        controller.title = Strings.Screen.trash
        controller.viewModel = context.trashStorage.makeViewModel()

        // TODO: fix this; need to set the grouping for trash view controller to .flat
        // because we cannot expand gropus in trash (the lookup is performed in main storage
        // when expanding groups)
        controller.grouping = .flat

        return controller
    })

    static func detailsForSingleRecord(with identifier: RecordIdentifier) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            guard let record = context.storage.all.first(where: { $0.identifier == identifier }) else {
                return UIViewController()
            }

            guard let questionnaire = try? Questionnaire(record: record) else {
                return UIViewController()
            }

            if record.answers.allStatementsAnswered(for: questionnaire) {
                return ViewControllerMaker.analysisForRecords(with: [identifier]).make(with: context)
            }
            else {
                return ViewControllerMaker.answersInputForRecord(with: identifier).make(with: context)
            }
        })
    }

    static func detailsForMultipleRecords(with identifiers: [RecordIdentifier]) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let controller = RecordsListViewController(style: .plain)

            let records = identifiers.compactMap({ identifier in
                context.storage.all.first(where: { $0.identifier == identifier })
            })
            .sorted(by: { $0.date > $1.date })

            guard let firstRecord = records.first, records.count > 1 else {
                return controller
            }

            controller.title = firstRecord.indexItem.personName
            controller.style = .nested(basedOn: firstRecord)
            controller.grouping = .flat

            attachAddRecordButton(to: controller)
            attachCompareRecordsButton(to: controller)

            controller.viewModel = context.storage.makeViewModel(includeRecord: { record in
                record.indexItem.personName.isEqual(firstRecord.indexItem.personName)
            })

            return controller
        })
    }
}


private func attachAddRecordButton(to controller: RecordsListViewController) {
    let button = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: controller,
        action: #selector(RecordsListViewController.addRecordButtonAction(_:))
    )

    controller.navigationItem.rightBarButtonItem = button
}

private func attachTrashButton(to controller: RecordsListViewController) {
    let button = UIBarButtonItem(
        barButtonSystemItem: .trash,
        target: controller,
        action: #selector(RecordsListViewController.trashButtonAction(_:))
    )

    controller.navigationItem.leftBarButtonItem = button
}

private func attachCompareRecordsButton(to controller: UITableViewController) {
    let compareButton = Views.makeSolidButton(title: Strings.Button.compare)

    compareButton.addTarget(
        controller,
        action: #selector(RecordsListViewController.compareRecordsButtonAction(_:)),
        for: .touchUpInside
    )

    controller.tableView.tableHeaderView = compareButton
}
