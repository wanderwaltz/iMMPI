import UIKit
import DataModel
import Localization
import Utils
import UITableViewModels
import UIReusableViews
import MMPIRouting

public final class RecordsListViewController: UITableViewController, UsingRouting {
    public var style: RecordsListViewControllerStyle = .root

    public var grouping: RecordsListViewControllerGrouping = .alphabetical {
        didSet {
            if isViewLoaded {
                viewModel?.setNeedsUpdate()
            }
        }
    }

    var searchController = UISearchController(searchResultsController: nil)

    public var viewModel: RecordsListViewModel<RecordProtocol>? {
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

    private var records: [RecordProtocol] = [] {
        didSet { groups = grouping.group(records.filter(recordsFilter)) }
    }

    private var recordsFilter: (RecordProtocol) -> Bool = Constant.value(true) {
        didSet { groups = grouping.group(records.filter(recordsFilter)) }
    }

    private var groups: Grouping<RecordsGroup> = .empty {
        didSet { reloadData() }
    }

    private var index: SectionIndex?
    private var cellSource: TableViewCellSource<RecordsGroup>!

    public override init(style: UITableView.Style) {
        super.init(style: style)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
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
        searchController.obscuresBackgroundDuringPresentation = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RecordsListViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setNeedsUpdate()
        tableView.tableHeaderView = searchController.searchBar
        cellSource.register(in: tableView)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateInsets()
    }

    private func updateInsets() {
        guard hasActiveSearchControllerInHierarchy() else {
            tableView.contentInset = .zero
            return
        }

        tableView.contentInset = .init(
            top: tableView.tableHeaderView?.bounds.height ?? 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }

    private func hasActiveSearchControllerInHierarchy() -> Bool {
        guard let navigationController = navigationController else {
            return searchController.isActive
        }

        return navigationController.viewControllers.first(where: {
            ($0 as? RecordsListViewController)?.searchController.isActive == true
        }) != nil
    }
}

extension RecordsListViewController {
    @IBAction public func addRecordButtonAction(_ sender: Any?) {
        router?.addRecord(basedOn: style.makeNewRecord(), sender: self)
    }

    @IBAction public func compareRecordsButtonAction(_ sender: Any?) {
        router?.displayAnalysis(
            for: Array(groups.allItems.map({ $0.allRecords() }).joined()),
            sender: self
        )
    }

    @IBAction public func trashButtonAction(_ sender: Any?) {
        router?.displayTrash(sender: self)
    }
}

extension RecordsListViewController {
    private func reloadData() {
        if (viewModel?.shouldProvideIndex ?? false) && groups.sections.count > 1 {
            index = groups.makeIndex()
        }
        else {
            index = nil
        }

        tableView.reloadData()
    }

    @objc private func handleDidEditRecordNotification(_ notification: Notification) {
        assert(Thread.isMainThread)
        guard let record = notification.object as? RecordProtocol else {
            return
        }

        viewModel?.setNeedsUpdate(completion: { _ in
            if let indexPath = self.groups.indexPathOfItem(matching: { $0.personName == record.personName }) {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        })

        router?.displayDetails(for: record, sender: self)
    }
}

// MARK: UITableViewDelegate
extension RecordsListViewController {
    public override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        router?.displayDetails(for: item, sender: self)
    }

    public override func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        router?.edit(item.record, sender: self)
    }

    public override func tableView(
        _ tableView: UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
    ) -> String? {
        return Strings.Button.delete
    }

    public override func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .delete
    }

    public override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard let item = groups.item(at: indexPath) else {
            return
        }

        for record in item.allRecords() {
            viewModel?.delete(record)
        }

        viewModel?.setNeedsUpdate()
    }
}

// MARK: UITableViewDataSource
extension RecordsListViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.numberOfSections
    }

    public override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return groups.numberOfItems(inSection: section)
    }

    public override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return groups.title(forSection: section)
    }

    public override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return cellSource.dequeue(from: tableView, for: indexPath, with: groups.item(at: indexPath))
    }

    public override func sectionIndexTitles(
        for tableView: UITableView
    ) -> [String]? {
        return index?.indexTitles
    }

    public override func tableView(
        _ tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        at index: Int
    ) -> Int {
        return self.index?.section(forIndexTitle: title) ?? 0
    }
}

extension RecordsListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        if text.count > 2 {
            let components = text
                .lowercased()
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
            recordsFilter = Constant.value(true)
        }
    }
}

extension RecordsListViewController: UISearchControllerDelegate {
    public func didDismissSearchController(_ searchController: UISearchController) {
        recordsFilter = Constant.value(true)
    }
}
