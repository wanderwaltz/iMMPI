import Foundation

protocol EditRecordViewControllerDelegate: class {
    func editRecordViewController(_ controller: EditRecordViewController,
                                  didFinishEditing record: Record,
                                  previousIdentifier: RecordIdentifier)

    func editRecordViewControllerDidCancel(_ controller: EditRecordViewController)
}
