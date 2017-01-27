import UIKit

extension UIViewController {
    func setEmptyBackBarButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}


enum Constant {
    static func void<A>() -> (A) -> () {
        return { _ in () }
    }


    static func bool<A>(_ value: Bool) -> (A) -> Bool {
        return { _ in value }
    }


    static func double<A>(_ value: Double) -> (A) -> Double {
        return { _ in value }
    }
    

    static func string<A>(_ value: String) -> (A) -> String {
        return { _ in value }
    }


    static func html<A>(_ value: Html) -> (A) -> Html {
        return { _ in value }
    }


    static func array<A, B>(_ value: [B]) -> (A) -> [B] {
        return { _ in value }
    }
}


func nilToEmptyString(_ value: Any?) -> String {
    return value.map { String(describing: $0) } ?? ""
}
