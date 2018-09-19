import Foundation

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
                                  didFinishEditing record: Record,
                                  previousIdentifier: RecordIdentifier) {
        controller.dismiss(animated: true, completion: nil)

        // remove record with previous identifier when saving record in case identifier has changed after editing
        try? storage.removeRecord(with: previousIdentifier)
        try? storage.store(record)

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
                               record: Record) {
        answersInputDelegate?.answersViewController(
            controller,
            didSet: answer,
            for: statement,
            record: record
        )
    }

    func answersInputViewController(_ controller: AnswersViewController,
                                    didSet answers: Answers,
                                    for record: Record) {
        var newRecord = record
        newRecord.answers = answers
        try? storage.store(newRecord)
    }
}


extension Notification.Name {
    static let didEditRecord = Notification.Name(rawValue: "com.immpi.notifications.didEditRecord")
}
