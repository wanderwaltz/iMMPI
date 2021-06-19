import UIKit
import MMPIRouting
import Localization

public final class ScaleDetailsViewController: UIViewController, UsingRouting {
    public var viewModel: ScaleDetailsViewModel? {
        didSet { reloadData() }
    }

    @IBOutlet private var collectionView: UICollectionView!

    public init() {
        super.init(
            nibName: String(describing: Self.self),
            bundle: .module
        )
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(_:))
        )
    }
}

extension ScaleDetailsViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(type: StatementCell.self)
        registerCell(type: ComputationTitleCell.self)
        registerCell(type: ComputationBodyCell.self)
        registerHeader(type: SectionHeader.self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    func reloadData() {
        title = viewModel?.title
        collectionView?.reloadData()
    }
}

extension ScaleDetailsViewController {
    @objc private func cancelButtonAction(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}

extension ScaleDetailsViewController: UICollectionViewDataSource {
    enum Section: Int, CaseIterable {
        case positiveKey
        case negativeKey
        case computation
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch Section(rawValue: section)! {
        case .positiveKey:
            return viewModel?.positiveKey.count ?? 0

        case .negativeKey:
            return viewModel?.negativeKey.count ?? 0

        case .computation:
            return (viewModel?.computationDetails.count ?? 0) * 2
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        switch Section(rawValue: indexPath.section)! {
        case .positiveKey:
            return sectionHeader(
                indexPath: indexPath,
                text: Strings.Analysis.statementsPositiveKey
            )

        case .negativeKey:
            return sectionHeader(
                indexPath: indexPath,
                text: Strings.Analysis.statementsNegativeKey
            )

        case .computation:
            return sectionHeader(
                indexPath: indexPath,
                text: Strings.Analysis.computation
            )
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }

        switch Section(rawValue: indexPath.section)! {
        case .positiveKey:
            return statementCell(indexPath: indexPath) { cell in
                cell.update(
                    statement: viewModel.positiveKey[indexPath.item],
                    style: .positive,
                    matching: viewModel.hasPositiveMatch(atIndex: indexPath.item)
                )
            }

        case .negativeKey:
            return statementCell(indexPath: indexPath) { cell in
                cell.update(
                    statement: viewModel.negativeKey[indexPath.item],
                    style: .negative,
                    matching: viewModel.hasNegativeMatch(atIndex: indexPath.item)
                )
            }

        case .computation:
            let computation = viewModel.computationDetails[indexPath.item / 2]

            if indexPath.item % 2 == 0 {
                return computationTitleCell(indexPath: indexPath, title: computation.title)
            }
            else {
                return computationBodyCell(indexPath: indexPath, text: computation.body)
            }
        }
    }

    private func sectionHeader(
        indexPath: IndexPath,
        text: String
    ) -> UICollectionReusableView {
        let header = dequeueHeader(type: SectionHeader.self, for: indexPath)
        header.setText(text)
        return header
    }

    private func statementCell(
        indexPath: IndexPath,
        update: (StatementCell) -> Void
    ) -> UICollectionViewCell {
        let cell = dequeueCell(type: StatementCell.self, for: indexPath)
        update(cell)
        return cell
    }

    private func computationTitleCell(
        indexPath: IndexPath,
        title: String
    ) -> UICollectionViewCell {
        let cell = dequeueCell(type: ComputationTitleCell.self, for: indexPath)
        cell.update(title: title)
        return cell
    }

    private func computationBodyCell(
        indexPath: IndexPath,
        text: String
    ) -> UICollectionViewCell {
        let cell = dequeueCell(type: ComputationBodyCell.self, for: indexPath)
        cell.update(text: text)
        return cell
    }

    private func registerCell<T: UICollectionViewCell>(type: T.Type) {
        collectionView.register(
            UINib(nibName: String(describing: T.self), bundle: .module),
            forCellWithReuseIdentifier: String(describing: T.self)
        )
    }

    private func registerHeader<T: UICollectionReusableView>(type: T.Type) {
        collectionView.register(
            UINib(nibName: String(describing: T.self), bundle: .module),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: T.self)
        )
    }

    private func dequeueCell<T: UICollectionViewCell>(
        type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as! T
    }

    private func dequeueHeader<T: UICollectionReusableView>(
        type: T.Type,
        for indexPath: IndexPath
    ) -> T {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as! T
    }
}


extension ScaleDetailsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        isSectionEmpty(section)
            ? .zero
            : .init(width: collectionView.bounds.width, height: 44)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        isSectionEmpty(section)
            ? .zero
            : .init(top: 16, left: 16, bottom: 0, right: 16)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch Section(rawValue: indexPath.section)! {
        case .positiveKey,
             .negativeKey:
            return .init(width: 44, height: 44)

        case .computation:
            let layout = collectionViewLayout as? UICollectionViewFlowLayout
            var width = collectionView.bounds.width
            width -= layout?.minimumInteritemSpacing ?? 0
            width -= layout?.sectionInset.left ?? 0
            width -= layout?.sectionInset.right ?? 0

            let computation = viewModel!.computationDetails[indexPath.item / 2]

            if indexPath.item % 2 == 0 {
                width *= computation.title.isEmpty ? 0 : 0.3
            }
            else {
                width *= computation.title.isEmpty ? 1 : 0.7
            }

            let cell = self.collectionView(collectionView, cellForItemAt: indexPath)
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            let height = cell.contentView.systemLayoutSizeFitting(
                .init(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            .height

            return .init(width: width, height: height + 16)
        }
    }

    private func isSectionEmpty(_ section: Int) -> Bool {
        switch Section(rawValue: section)! {
        case .positiveKey:
            return viewModel?.positiveKey.isEmpty ?? true

        case .negativeKey:
            return viewModel?.negativeKey.isEmpty ?? true

        case .computation:
            return viewModel?.computationDetails.isEmpty ?? true
        }
    }
}
