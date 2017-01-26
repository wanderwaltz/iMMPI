import Foundation

extension MMPIRouter {
    final class EditingDelegate {
        weak var answersInputDelegate: TestAnswersInputDelegate?
        
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
            storage.update(record)
        }
        else {
            storage.add(record)
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


extension MMPIRouter.EditingDelegate: TestAnswersInputDelegate {
    func testAnswersViewController(_ controller: TestAnswersViewController,
                                   didSet answer: AnswerType,
                                   for statement: Statement,
                                   record: RecordProtocol) {
        answersInputDelegate?.testAnswersViewController(
            controller,
            didSet: answer,
            for: statement,
            record: record
        )
    }

    func testAnswersInputViewController(_ controller: TestAnswersViewController,
                                        didSet answers: TestAnswers,
                                        for record: RecordProtocol) {
        record.testAnswers = answers
        storage.update(record)
    }
}


extension Notification.Name {
    static let didEditRecord = Notification.Name(rawValue: "com.immpi.notifications.didEditRecord")
}
