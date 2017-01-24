import UIKit
import MessageUI

final class AnalysisViewController: UITableViewController, UsingRouting {
    var record: TestRecordProtocol? {
        didSet {
            title = record.map { "\($0.person.name), \(dateFormatter.string(from: $0.date))" } ?? ""
            bindAnalyser()
        }
    }

    let analyser = Analyser()

    var settings: AnalysisSettings?
    var cellSource: AnalyserTableViewCell.Source = AnalyserTableViewCell.makeSource()

    override init(style: UITableViewStyle) {
        super.init(style: style)
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

    fileprivate let dateFormatter = DateFormatter.medium
    fileprivate var analyserGroupIndices: [Int] = []
    fileprivate var boundScales: [BoundScale] = []
}


extension AnalysisViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSource.register(in: tableView)
        reloadData()
    }
}


extension AnalysisViewController {
    @objc @IBAction fileprivate func handleAnswersReviewButtonAction(_ sender: Any?) {
        guard let record = record else {
            return
        }

        router?.displayAnswersReview(for: record, sender: self)
    }


    @objc @IBAction fileprivate func handleAnalysisOptionsButtonAction(_ sender: Any?) {
        guard let record = record else {
            return
        }

        router?.displayAnalysisOptions(
            context: AnalysisMenuActionContext(router: router, record: record, scales: boundScales),
            sender: self
        )
    }
}


extension AnalysisViewController {
    @objc fileprivate func handleAnalysisSettingsDidChangeNotificaion(_ notification: Notification) {
        reloadData()
    }
}


extension AnalysisViewController {
    func reloadData() {
        var indices: [Int] = []

        for (i, scale) in boundScales.enumerated() {
            if false == scale.score.isWithinNorm || false == settings?.shouldHideNormalResults {
                indices.append(i)
            }
        }

        let oldIndicesWereEmpty = analyserGroupIndices.isEmpty

        analyserGroupIndices = indices

        guard self.isViewLoaded else {
            return
        }

        if oldIndicesWereEmpty {
            tableView.reloadData()
        }
        else {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }


    fileprivate func bindAnalyser() {
        guard let record = record else {
            return
        }

        DispatchQueue.global().async {
            let bound = self.analyser.bind(record)

            DispatchQueue.main.async {
                self.boundScales = bound
                self.reloadData()
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension AnalysisViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyserGroupIndices.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = analyserGroupIndices[indexPath.row]
        return cellSource.dequeue(from: tableView, with: boundScales[index])
    }
}
