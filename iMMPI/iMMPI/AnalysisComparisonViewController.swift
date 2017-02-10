import UIKit

final class AnalysisComparisonViewController: UIViewController, UsingRouting {
    var viewModel: AnalysisComparisonViewModel? {
        didSet {
            title = viewModel?.title

            if isViewLoaded {
                reloadData()
            }
        }
    }

    var settings: AnalysisSettings?


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        setEmptyBackBarButtonTitle()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Strings.Button.answers,
            style: .plain,
            target: self,
            action: #selector(handleAnswersReviewButtonAction(_:))
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(handleAnalysisOptionsButtonAction(_:))
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAnalysisSettingsDidChangeNotificaion(_:)),
            name: .analysisSettingsChanged,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    fileprivate let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: AnalysisComparisonCollectionViewLayout()
    )

    fileprivate let scaleCellSource: CollectionViewCellSource<BoundScale> =
        AnalysisScaleCollectionViewCell.makeSource()

    fileprivate let scoreCellSource: CollectionViewCellSource<BoundScale> =
        AnalysisScoreCollectionViewCell.makeSource()

    fileprivate let dateHeaderCellSource: CollectionViewCellSource<Date> =
        AnalysisDateHeaderCollectionViewCell.makeSource()

    fileprivate var analyserGroupIndices: [Int] = []
}


extension AnalysisComparisonViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)

        scaleCellSource.register(in: collectionView)
        scoreCellSource.register(in: collectionView)
        dateHeaderCellSource.register(in: collectionView)

        collectionView.isDirectionalLockEnabled = true
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.dataSource = self

        reloadData()
    }
}


extension AnalysisComparisonViewController {
    fileprivate func reloadData() {
        guard let results = viewModel?.results, results.count > 0 else {
            analyserGroupIndices = []
            return
        }

        var indices: [Int] = []

        let scalesCount = results.first!.scales.count

        for i in 0..<scalesCount {
            let anyScoreNotWithinNorm = results.reduce(false, { $0 || false == $1.scales[i].score.isWithinNorm })
            if anyScoreNotWithinNorm || false == settings?.shouldHideNormalResults {
                indices.append(i)
            }
        }

        let oldIndicesWereEmpty = analyserGroupIndices.isEmpty

        analyserGroupIndices = indices
        collectionView.reloadData()
    }
}


extension AnalysisComparisonViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 + (viewModel?.results.count ?? 0)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + analyserGroupIndices.count
    }


    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return dateHeaderCellSource.dequeue(
                from: collectionView,
                for: indexPath,
                with: nil
            )

        case (_, 0):
            return dateHeaderCellSource.dequeue(
                from: collectionView,
                for: indexPath,
                with: viewModel?.results[indexPath.section-1].date
            )

        case (0, _):
            return scaleCellSource.dequeue(
                from: collectionView,
                for: indexPath,
                with: viewModel?.results.first?.scales[analyserGroupIndices[indexPath.row-1]]
            )

        default:
            return scoreCellSource.dequeue(
                from: collectionView,
                for: indexPath,
                with: viewModel?.results[indexPath.section-1].scales[analyserGroupIndices[indexPath.row-1]]
            )
        }
    }
}


extension AnalysisComparisonViewController {
    @objc @IBAction fileprivate func handleAnswersReviewButtonAction(_ sender: Any?) {
        guard let record = viewModel?.results.first?.record else {
            return
        }

        router?.displayAnswersReview(for: record, sender: self)
    }


    @objc @IBAction fileprivate func handleAnalysisOptionsButtonAction(_ sender: Any?) {
        guard let result = viewModel?.results.first else {
            return
        }

        router?.displayAnalysisOptions(
            context: AnalysisMenuActionContext(router: router, result: result),
            sender: self
        )
    }
}


extension AnalysisComparisonViewController {
    @objc fileprivate func handleAnalysisSettingsDidChangeNotificaion(_ notification: Notification) {
        reloadData()
    }
}
