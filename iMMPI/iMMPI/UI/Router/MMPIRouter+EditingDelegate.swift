import Foundation
import DataModel

extension MMPIRouter {
    final class EditingDelegate {
        weak var answersInputDelegate: AnswersInputDelegate?
        
        init(storage: RecordStorage) {
            self.storage = storage
        }

        fileprivate let storage: RecordStorage
    }
}


extension MMPIRouter.EditingDelegate: EditRecordViewControllerDelegate {
    func editRecordViewController(_ controller: EditRecordViewController,
                                      didFinishEditing record: RecordProtocol) {
        controller.dismiss(animated: true, completion: nil)

        if storage.contains(record) {
            try? storage.update(record)
        }
        else {
            try? storage.add(record)
        }

        NotificationCenter.default.post(
            Notification(
                name: .didEditRecord,
                object: record,
                userInfo: nil
            )
        )
    }


    func editRecordViewControllerDidCancel(_ controller: EditRecordViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension MMPIRouter.EditingDelegate: AnswersInputDelegate {
    func answersViewController(_ controller: AnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {
        answersInputDelegate?.answersViewController(
            controller,
            didSet: answer,
            for: statement,
            record: record
        )
    }

    func answersInputViewController(_ controller: AnswersViewController,
                                        didSet answers: Answers,
                                        for record: RecordProtocol) {
        record.answers = answers
        try? storage.update(record)
    }
}


extension Notification.Name {
    static let didEditRecord = Notification.Name(rawValue: "com.immpi.notifications.didEditRecord")
}
