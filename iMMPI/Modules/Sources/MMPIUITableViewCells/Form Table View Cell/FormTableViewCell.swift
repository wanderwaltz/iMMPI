import UIKit

public class FormTableViewCell: UITableViewCell {
    public var layout: Layout = .default {
        didSet { setNeedsLayout() }
    }

    private(set) var rightContentView: UIView!

    public init(reuseIdentifier: String) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
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
    override public func layoutSubviews() {
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
    public struct Layout {
        public let contentMargin: CGFloat
        public let titleMargin: CGFloat
        public let titleWidth: () -> CGFloat

        public init(
            contentMargin: CGFloat,
            titleMargin: CGFloat,
            titleWidth: @escaping () -> CGFloat
        ) {
            self.contentMargin = contentMargin
            self.titleMargin = titleMargin
            self.titleWidth = titleWidth
        }
    }
}


extension FormTableViewCell.Layout {
    public static let `default` = FormTableViewCell.Layout(
        contentMargin: 20.0,
        titleMargin: 20.0,
        titleWidth: { 0.0 }
    )
}
