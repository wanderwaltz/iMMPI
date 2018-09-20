import Foundation
import MessageUI

protocol ViewControllersFactory {
    var screenDescriptorSerialization: ScreenDescriptorSerialization { get }

    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController
}
