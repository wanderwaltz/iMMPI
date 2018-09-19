import UIKit

extension UIViewController {
    func setEmptyBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}


enum Constant<T> {
    static func value(_ constant: T) -> () -> T {
        return { constant }
    }

    static func value<A1>(_ constant: T) -> (A1) -> T {
        return { _ in constant }
    }

    static func value<A1, A2>(_ constant: T) -> (A1, A2) -> T {
        return { _, _ in constant }
    }
}


func nilToEmptyString(_ value: Any?) -> String {
    return value.map { String(describing: $0) } ?? ""
}
