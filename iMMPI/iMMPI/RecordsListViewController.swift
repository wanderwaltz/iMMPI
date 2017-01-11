import UIKit

final class RecordsListViewController: UITableViewController, UsingRouting {
    var style: RecordsListViewControllerStyle = .root

    var grouping: RecordsListViewControllerGrouping = .alphabetical {
        didSet {
            if isViewLoaded {
                viewModel?.setNeedsUpdate()
            }
        }
    }

    var searchController = UISearchController(searchResultsController: nil)

    var viewModel: ListViewModel<TestRecordProtocol>? {
        willSet {
            viewModel?.onDidUpdate = Constant.void()
        }

        didSet {
            viewModel?.onDidUpdate = { [weak self] records in
                self?.records = records
            }

            if isViewLoaded {
                viewModel?.setNeedsUpdate()
            }
        }
    }


    override init(style: UITableViewStyle) {
        super.init(style: style)
        setup()
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    fileprivate func setup() {
        cellSource = TableViewCellSource(
            style: .value1,
            identifier: "com.immpi.cells.recordsGroup",
            update: { [weak self] cell, group in
                if let group = group {
                    self?.style.update(cell, with: group)
                }
        })

        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidEditRecordNotification(_:)),
            name: .didEditRecord,
            object: nil
        )

        searchController.searchResultsUpdater = self
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    fileprivate var records: [TestRecordProtocol] = [] {
        didSet {
            groups = grouping.group(records.filter(recordsFilter))
        }
    }


    fileprivate var recordsFilter: (TestRecordProtocol) -> Bool = Constant.bool(true) {
        didSet {
            groups = grouping.group(records.filter(recordsFilter))
        }
    }


    fileprivate var groups: Grouping<TestRecordsGroup> = .empty {
        didSet {
            reloadData()
        }
    }


    fileprivate var index: SectionIndex?
    fileprivate var cellSource: TableViewCellSource<TestRecordsGroup>!
}


extension RecordsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setNeedsUpdate()
        tableView.tableHeaderView = searchController.searchBar
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }
}


extension RecordsListViewController {
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


extension RecordsListViewController {
    @IBAction func addRecordButtonAction(_ sender: Any?) {
        try? router?.addRecord(basedOn: style.makeNewRecord(), sender: self)
    }
}


extension RecordsListViewController {
    fileprivate func reloadData() {
        if (viewModel?.shouldProvideIndex ?? false) && groups.sections.count > 1 {
            index = groups.makeIndex()
        }
        else {
            index = nil
        }

        tableView.reloadData()
    }


    @objc fileprivate func handleDidEditRecordNotification(_ notification: Notification) {
        assert(Thread.isMainThread)
        guard let record = notification.object as? TestRecordProtocol else {
            return
        }

        viewModel?.setNeedsUpdate(completion: { _ in
            if let indexPath = self.groups.indexPathOfItem(matching: { $0.personName == record.personName }) {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        })

        try? router?.displayAnswersInput(for: record, sender: self)
    }
}


// MARK: - UITableViewDelegate
extension RecordsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        try? router?.displayDetails(for: item, sender: self)
    }


    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        try? router?.edit(item.record, sender: self)
    }


    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return Strings.delete
    }


    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }


    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        for record in item.allRecords() {
            viewModel?.delete(record)
        }

        viewModel?.setNeedsUpdate()
    }
}


// MARK: - UITableViewDataSource
extension RecordsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.numberOfSections
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.numberOfItems(inSection: section)
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups.title(forSection: section)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellSource.dequeue(from: tableView, with: groups.item(at: indexPath))
    }


    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return index?.indexTitles
    }


    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.index?.section(forIndexTitle: title) ?? 0
    }
}


extension RecordsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        if text.characters.count > 2 {
            let components = text.lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .whitespacesAndNewlines)

            recordsFilter = { record in
                let personName = record.personName.lowercased()

                for searchTerm in components {
                    if false == searchTerm.isEmpty && false == personName.contains(searchTerm) {
                        return false
                    }
                }

                return true
            }
        }
        else {
            recordsFilter = Constant.bool(true)
        }
    }
}


extension RecordsListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        recordsFilter = Constant.bool(true)
    }
}
