import Foundation
import MessageUI

final class RoutedViewControllersFactory: ViewControllersFactory {
    weak var router: Router?

    let base: ViewControllersFactory

    init(base: ViewControllersFactory) {
        self.base = base
    }

    var screenDescriptorSerialization: ScreenDescriptorSerialization {
        return base.screenDescriptorSerialization
    }

    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController {
        let controller = base.makeViewController(for: descriptor)
        (controller as? UsingRouting)?.router = router

        return controller
    }
}
