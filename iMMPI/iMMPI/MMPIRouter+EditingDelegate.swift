import Foundation

extension MMPIRouter {
    final class EditingDelegate: NSObject, EditTestRecordViewControllerDelegate {
        func editTestRecordViewController(_ controller: EditTestRecordViewController,
                                          didFinishEditing record: TestRecordProtocol?) {
            controller.dismiss(animated: true, completion: nil)

            if let record = record {
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
        }


        init(storage: TestRecordStorage) {
            self.storage = storage
        }


        fileprivate let storage: TestRecordStorage
    }
}


extension Notification.Name {
    static let didEditRecord = Notification.Name(rawValue: "com.immpi.notifications.didEditRecord")
}