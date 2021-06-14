import UIKit
import MMPIRoutingProduction

final class Application: UIApplication, LastTouchedViewProviding {
    private(set) var lastTouchedView: UIView?

    override func sendEvent(_ event: UIEvent) {
        lastTouchedView = nil

        switch event.type {
        case .touches:
            guard let touches = event.allTouches, let touch = touches.first, touches.count == 1 else {
                return
            }

            lastTouchedView = touch.view

        default: break
        }

        super.sendEvent(event)
    }
}
