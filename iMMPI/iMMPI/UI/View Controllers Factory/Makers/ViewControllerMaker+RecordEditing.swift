import UIKit

extension ViewControllerMaker {
    static func addRecord(_ record: Record) -> ViewControllerMaker {
        return edit(record, title: Strings.Screen.newRecord)
    }

    static func editRecord(with identifier: RecordIdentifier) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let record = context.storage.findRecord(with: identifier) ?? Record()
            return ViewControllerMaker.edit(record, title: Strings.Screen.editRecord).make(with: context)
        })
    }

    private static func edit(_ record: Record, title: String) -> ViewControllerMaker {
        return ViewControllerMaker({ context in
            let controller = EditRecordViewController(style: .grouped)

            controller.record = record
            controller.title =  title
            controller.delegate = context.editRecordViewControllerDelegate

            return controller
        })
    }
}
