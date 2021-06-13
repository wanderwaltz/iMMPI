import Foundation

public protocol RecordIndexItem: PersonNameConvertible, DateConvertible {
    func settingPersonName(_ name: String) -> Self
    func settingDate(_ date: Date) -> Self
}
