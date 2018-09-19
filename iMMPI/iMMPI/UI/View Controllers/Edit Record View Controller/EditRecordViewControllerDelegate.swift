import Foundation

protocol EditRecordViewControllerDelegate: class {
    func editRecordViewController(_ controller: EditRecordViewController,
                                  didFinishEditing record: RecordProtocol)

    func editRecordViewControllerDidCancel(_ controller: EditRecordViewController)
}
