import Foundation

protocol RecordIndexItem {
    var personName: String { get }
    var date: Date { get }

    func settingPersonName(_ name: String) -> Self
    func settingDate(_ date: Date) -> Self
}
