import UIKit

extension UIView {
    func addRightBorder(color: UIColor = Colors.separator,
                        topMargin: CGFloat = 0.0,
                        bottomMargin: CGFloat = 0.0) {
        let border = UIView(frame: .zero)

        border.isUserInteractionEnabled = false
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false

        addSubview(border)

        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: topMargin
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: -bottomMargin
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .right,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: 1.0 / UIScreen.main.scale
            )
        )
    }


    func addBottomBorder(color: UIColor = Colors.separator,
                         leftMargin: CGFloat = 0.0,
                         rightMargin: CGFloat = 0.0) {
        let border = UIView(frame: .zero)

        border.isUserInteractionEnabled = false
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false

        addSubview(border)

        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .left,
                relatedBy: .equal,
                toItem: self,
                attribute: .left,
                multiplier: 1,
                constant: leftMargin
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .right,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: -rightMargin
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            )
        )


        addConstraint(
            NSLayoutConstraint(
                item: border,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 1.0 / UIScreen.main.scale
            )
        )
    }

}
