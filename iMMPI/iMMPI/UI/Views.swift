import UIKit

enum Views {
    static let singlePixel: CGFloat = 1.0 / UIScreen.main.scale
    static let controlSize: CGFloat = 44.0

    static func makeSolidButton(title: String) -> UIButton {
        let button = UIButton(type: .system)

        button.frame = .init(x: 0, y: 0, width: 320, height: controlSize)
        button.backgroundColor = Colors.solidButtonBackground
        button.layer.borderColor = Colors.solidButtonBorder.cgColor
        button.layer.borderWidth = singlePixel
        button.titleLabel?.font = Fonts.solidButtonTitle

        button.setTitle(title, for: .normal)

        return button
    }
}
