import UIKit

protocol AnalysisOptionsViewControllerDelegate: class {
    func analysisOptionsViewControllerSettingsChanged(_ controller: AnalysisOptionsViewController)
}


final class AnalysisOptionsViewController: UITableViewController, UsingRouting {
    weak var delegate: AnalysisOptionsViewControllerDelegate?

    var viewModel: AnalysisOptionsViewModel? {
        willSet {
            viewModel?.onDidUpdate = Constant.void()
        }

        didSet {
            viewModel?.onDidUpdate = { [weak self] switchRows in
                self?.switchRows = switchRows
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    func setup() {
        preferredContentSize = CGSize(width: 320.0, height: 44.0 * 6)
        switchCellSource = .switch { [weak self] (cell, `switch`, data) in
            cell.selectionStyle = .none
            cell.textLabel?.text = data?.title ?? ""
            `switch`.isOn = data?.value ?? false

            if let this = self {
                `switch`.removeTarget(
                    this,
                    action: #selector(AnalysisOptionsViewController.switchValueChanged(_:)),
                    for: [.valueChanged]
                )

                `switch`.addTarget(
                    this,
                    action: #selector(AnalysisOptionsViewController.switchValueChanged(_:)),
                    for: [.valueChanged]
                )
            }
        }
    }

    fileprivate typealias SwitchCellData = AnalysisOptionsViewModel.SwitchCellData

    fileprivate var switchCellSource: TableViewCellSource<SwitchCellData>!
    fileprivate var switchRows = Section<SwitchCellData>(title: "", items: [])
}


extension AnalysisOptionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setNeedsUpdate()
    }
}


extension AnalysisOptionsViewController {
    @objc fileprivate func switchValueChanged(_ sender: UISwitch) {
        viewModel?.toggleSwitch(atIndex: sender.tag)
        delegate?.analysisOptionsViewControllerSettingsChanged(self)
    }
}


// MARK: - UITableViewDataSource
extension AnalysisOptionsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return switchRows.items.count
        default: return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = switchCellSource.dequeue(from: tableView, with: switchRows.items[indexPath.row])
            (cell.accessoryView as? UISwitch)?.tag = indexPath.row
            return cell
        default:
            assertionFailure()
            return UITableViewCell()
        }
    }
}
