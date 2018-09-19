import Foundation

protocol RecordIndexItem: PersonNameConvertible {
    var date: Date { get }

    func settingPersonName(_ name: String) -> Self
    func settingDate(_ date: Date) -> Self
}
