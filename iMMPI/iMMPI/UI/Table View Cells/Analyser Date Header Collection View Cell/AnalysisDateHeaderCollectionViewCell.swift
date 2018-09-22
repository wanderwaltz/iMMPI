import UIKit

final class AnalysisDateHeaderCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        finalizeInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    private func finalizeInit() {
        contentView.backgroundColor = .white
        contentView.addBottomBorder()
        contentView.addRightBorder()
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.frame = contentView.bounds
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.analysisDateHeaderTitle
        titleLabel.textColor = Colors.darkText
        titleLabel.text = ""

        contentView.addSubview(titleLabel)
    }
}
