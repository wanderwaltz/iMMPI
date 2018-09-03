import UIKit

final class Application: UIApplication {
    // This is used for showing a popover without explicitly specified its source view.
    // The last view that has been touched by the user is used as a source instead.
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
