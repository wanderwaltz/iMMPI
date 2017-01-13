import UIKit
import MessageUI

final class AnalysisViewController: UITableViewController, UsingRouting {
    var record: TestRecordProtocol? {
        didSet {
            title = record.map { "\($0.person.name), \(dateFormatter.string(from: $0.date))" } ?? ""
        }
    }

    var analyser: Analyzer?

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
            title: Strings.answers,
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
    fileprivate let reportGenerator = AnalysisHTMLReportGenerator()
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
        try? router?.displayAnalysisOptions(sender: self, origin: navigationItem.rightBarButtonItem!)
    }
}


extension AnalysisViewController {
    @objc fileprivate func handleAnalysisSettingsDidChangeNotificaion(_ notification: Notification) {
        reloadData()
    }
}


extension AnalysisViewController {
    func reloadData() {
        guard let analyser = analyser else {
            return
        }

        var indices: [Int] = []

        for i in 0..<analyser.groupsCount {
            guard let group = analyser.group(at: i) else {
                continue
            }

            if false == group.scoreIsWithinNorm() || false == settings?.shouldHideNormalResults {
                indices.append(i)
            }
        }

        analyserGroupIndices = indices
        tableView.reloadData()
    }


    fileprivate func initAnalyzerInBackgroundIfNeeded() {
        guard let record = record else {
            assertionFailure()
            return
        }

        guard analyser == nil else {
            return
        }

        DispatchQueue.global().async {
            let analyser = Analyzer()

            self.reportGenerator.analyzer = analyser
            self.reportGenerator.record = record

            self.reportGenerator.questionnaire =
                try? Questionnaire(gender: record.person.gender, ageGroup: record.person.ageGroup)

            analyser.loadGroups()
            analyser.computeScores(forRecord: record)

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
        let groupIndex = analyserGroupIndices[indexPath.row]

        let data = record.flatMap({ record in
            analyser?.group(at: groupIndex).flatMap({ group in
                (analyser?.depthOfGroup(at: groupIndex)).flatMap({ depth in
                    (group, record, depth)
                })
            })
        })

        return cellSource.dequeue(from: tableView, with: data)
    }
}
