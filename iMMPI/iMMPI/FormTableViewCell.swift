import UIKit

class FormTableViewCell: UITableViewCell {
    var layout: Layout = .default {
        didSet {
            setNeedsLayout()
        }
    }

    private(set) var rightContentView: UIView!

    init(reuseIdentifier: String) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        rightContentView = UIView()
        rightContentView.frame = contentView.bounds
        contentView.addSubview(rightContentView)

        selectionStyle = .none

        textLabel?.font = .boldSystemFont(ofSize: 14.0)
        textLabel?.textAlignment = .right
    }
}


extension FormTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds

        var titleFrame = CGRect.zero

        let titleWidth = layout.titleWidth()

        titleFrame.origin.x = layout.contentMargin
        titleFrame.origin.y = 0.0
        titleFrame.size.width = (titleWidth > 0) ? titleWidth : (textLabel?.intrinsicContentSize.width ?? 0.0)
        titleFrame.size.height = bounds.height

        textLabel?.frame = titleFrame.integral

        titleFrame.origin.x = titleFrame.maxX + layout.titleMargin
        titleFrame.size.width = bounds.width - titleFrame.origin.x - layout.contentMargin

        rightContentView.frame = titleFrame.integral
    }
}


extension FormTableViewCell {
    struct Layout {
        let contentMargin: CGFloat
        let titleMargin: CGFloat
        let titleWidth: () -> CGFloat
    }
}


extension FormTableViewCell.Layout {
    static let `default` = FormTableViewCell.Layout(contentMargin: 20.0, titleMargin: 20.0, titleWidth: { 0.0 })
}
