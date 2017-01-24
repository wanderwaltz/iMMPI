import UIKit
import MessageUI

final class AnalysisViewController: UITableViewController, UsingRouting {
    var record: TestRecordProtocol? {
        didSet {
            title = record.map { "\($0.person.name), \(dateFormatter.string(from: $0.date))" } ?? ""
        }
    }

    var analyser: Analyser?

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
}


extension AnalysisViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSource.register(in: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initAnalyzerInBackgroundIfNeeded()
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
        guard let analyser = analyser, let record = record else {
            return
        }

        router?.displayAnalysisOptions(
            context: AnalysisMenuActionContext(router: router, record: record, analyser: analyser),
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
        guard let analyser = analyser, let record = record else {
            return
        }

        var indices: [Int] = []

        for i in 0..<analyser.scales.count {
            let scale = analyser.scales[i]
            let score = scale.score.value(for: record)

            if false == scale.filter.isWithinNorm(score) || false == settings?.shouldHideNormalResults {
                indices.append(i)
            }
        }

        let oldIndicesWereEmpty = analyserGroupIndices.isEmpty

        analyserGroupIndices = indices

        if oldIndicesWereEmpty {
            tableView.reloadData()
        }
        else {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }


    fileprivate func initAnalyzerInBackgroundIfNeeded() {
        guard analyser == nil else {
            return
        }

        DispatchQueue.global().async {
            let analyser = Analyser()

            DispatchQueue.main.async {
                self.analyser = analyser
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

        let data = record.flatMap({ record in
            (analyser?.scales[index]).flatMap({ scale in
                (scale, record)
            })
        })

        return cellSource.dequeue(from: tableView, with: data)
    }
}
