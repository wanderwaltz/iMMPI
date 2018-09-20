import Foundation
import MessageUI

protocol ViewControllersFactory {
    func makeViewController(for descriptor: ScreenDescriptor) -> UIViewController
}
