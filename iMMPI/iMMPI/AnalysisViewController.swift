import UIKit
import MessageUI

final class AnalysisViewController: UITableViewController, UsingRouting {
    var record: RecordProtocol? {
        didSet {
            title = record.map { "\($0.person.name), \(dateFormatter.string(from: $0.date))" } ?? ""
            if let record = record {
                analysisResult = analyser.result(for: record)
            }
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
    fileprivate var analysisResult: AnalysisResult?
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
        guard let analysisResult = analysisResult else {
            return
        }

        router?.displayAnalysisOptions(
            context: AnalysisMenuActionContext(router: router, result: analysisResult),
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
        guard let result = analysisResult else {
            return
        }

        var indices: [Int] = []

        for (i, scale) in result.scales.enumerated() {
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
        return cellSource.dequeue(from: tableView, for: indexPath, with: analysisResult?.scales[index])
    }
}
