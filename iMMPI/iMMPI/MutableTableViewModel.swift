import UIKit

extension MutableTableViewModel {
    var first: Any? {
        return object(at: IndexPath(row: 0, section: 0))
    }
}
