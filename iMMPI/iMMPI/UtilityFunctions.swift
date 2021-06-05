import UIKit

extension UIViewController {
    func setEmptyBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}


enum Constant<T> {
    static func value<Arg>(_ constant: T) -> (Arg) -> T {
        return { _ in constant }
    }

    static func value<A, B>(_ constant: T) -> (A, B) -> T {
        return { _, _ in constant }
    }
}


func nilToEmptyString(_ value: Any?) -> String {
    return value.map { String(describing: $0) } ?? ""
}
