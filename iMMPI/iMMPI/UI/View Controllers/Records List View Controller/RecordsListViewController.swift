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

    let searchController = UISearchController(searchResultsController: nil)

    var viewModel: RecordsListViewModel<Record>? {
        willSet {
            viewModel?.onDidUpdate = Constant.value(())
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


    override init(style: UITableView.Style) {
        super.init(style: style)
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

        setEmptyBackBarButtonTitle()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidEditRecordNotification(_:)),
            name: .didEditRecord,
            object: nil
        )

        searchController.searchResultsUpdater = self
        searchController.delegate = self
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    fileprivate var records: [Record] = [] {
        didSet {
            groups = grouping.group(records.filter(recordsFilter))
        }
    }


    fileprivate var recordsFilter: (Record) -> Bool = Constant.value(true) {
        didSet {
            groups = grouping.group(records.filter(recordsFilter))
        }
    }


    fileprivate var groups: Grouping<RecordsGroup> = .empty {
        didSet {
            reloadData()
        }
    }


    fileprivate var index: SectionIndex?
    fileprivate var cellSource: TableViewCellSource<RecordsGroup>!

    fileprivate var highlightedRecordIdentifier: RecordIdentifier?
}


extension RecordsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setNeedsUpdate()
        tableView.tableHeaderView = searchController.searchBar
        cellSource.register(in: tableView)
    }
}


extension RecordsListViewController {
    @objc func trashButtonAction(_ sender: Any?) {
        router?.displayTrash(sender: self)
    }

    @objc func addRecordButtonAction(_ sender: Any?) {
        router?.addRecord(basedOn: style.makeNewRecord(), sender: self)
    }

    @objc func compareRecordsButtonAction(_ sender: Any?) {
        let records = groups.allItems.map({ $0.allRecords() }).joined()
        let recordIdentifiers = records.map({ $0.identifier })
        router?.displayAnalysis(for: recordIdentifiers, sender: self)
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

        if let indexPath = groups.indexPathOfItem(matching: { $0.record.identifier == highlightedRecordIdentifier }) {
            let scrollPosition: UITableView.ScrollPosition =
                tableView.indexPathsForVisibleRows?.contains(indexPath) == true
                    ? .none
                    : .middle

            tableView.selectRow(at: indexPath, animated: false, scrollPosition: scrollPosition)
        }
    }


    @objc fileprivate func handleDidEditRecordNotification(_ notification: Notification) {
        assert(Thread.isMainThread)
        guard let record = notification.object as? Record else {
            return
        }

        viewModel?.setNeedsUpdate(completion: { _ in
            if let indexPath = self.indexPathForMostRelevantItem(for: record) {
                self.highlightedRecordIdentifier = self.groups.item(at: indexPath)?.record.identifier
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        })

        router?.displayDetails(for: [record.identifier], sender: self)
    }

    private func indexPathForMostRelevantItem(for record: Record) -> IndexPath? {
        if let strictIndexPath =
            groups.indexPathOfItem(matching: { $0.record.identifier == record.identifier }) {
                return strictIndexPath
        }
        else if let samePersonIndexPath =
            groups.indexPathOfItem(matching: { $0.personName == record.indexItem.personName }) {
                return samePersonIndexPath
        }
        else {
            return nil
        }
    }
}


// MARK: - UITableViewDelegate
extension RecordsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let group = groups.item(at: indexPath) else {
            return
        }

        let recordIdentifiers = group.allRecords().map({ $0.identifier })
        highlightedRecordIdentifier = recordIdentifiers.first

        router?.displayDetails(for: recordIdentifiers, sender: self)
    }


    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        router?.editRecord(with: item.record.identifier, sender: self)
    }


    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return Strings.Button.delete
    }


    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }


    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
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
        return cellSource.dequeue(from: tableView, for: indexPath, with: groups.item(at: indexPath))
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

        if text.count > 2 {
            let components = text.lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .whitespacesAndNewlines)

            recordsFilter = { record in
                let personName = record.indexItem.personName.lowercased()

                for searchTerm in components {
                    if false == searchTerm.isEmpty && false == personName.contains(searchTerm) {
                        return false
                    }
                }

                return true
            }
        }
        else {
            recordsFilter = Constant.value(true)
        }
    }
}


extension RecordsListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        recordsFilter = Constant.value(true)
    }
}


// MARK: state restoration
extension RecordsListViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(highlightedRecordIdentifier?.rawValue, forKey: Key.highlightedRecordIdentifier)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        highlightedRecordIdentifier =
            (coder.decodeObject(forKey: Key.highlightedRecordIdentifier) as? String)
                .flatMap(RecordIdentifier.init)
    }
}


private enum Key {
    static let highlightedRecordIdentifier = "highlighted-record-identifier"
}
