import UIKit
import Localization
import Analysis
import Utils
import UITableViewModels
import UIReusableViews

// TODO: make internal data representation type-safe

protocol AnalysisOptionsViewControllerDelegate: AnyObject {
    func analysisOptionsViewControllerSettingsChanged(_ controller: AnalysisOptionsViewController)
}


final class AnalysisOptionsViewController: UITableViewController, UsingRouting {
    weak var delegate: AnalysisOptionsViewControllerDelegate?

    var viewModel: AnalysisOptionsViewModel? {
        willSet {
            viewModel?.onDidUpdate = Constant.value(())
        }

        didSet {
            viewModel?.onDidUpdate = { [weak self] switchRows, actionRows in
                self?.switchRows = switchRows
                self?.actionRows = actionRows
                self?.tableView.reloadSections(IndexSet(integersIn: 0..<2), with: .automatic)
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


    func setup() {
        title = Strings.Screen.analysisOptions
        setEmptyBackBarButtonTitle()

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

        actionCellSource = TableViewCellSource(
            style: .default,
            identifier: "com.immpi.cells.default",
            update: { cell, menuAction in
                cell.textLabel?.text = menuAction?.title ?? ""
                cell.accessoryType = .disclosureIndicator
        })
    }

    fileprivate typealias SwitchCellData = AnalysisOptionsViewModel.SwitchCellData

    fileprivate var switchCellSource: TableViewCellSource<SwitchCellData>!
    fileprivate var actionCellSource: TableViewCellSource<MenuAction>!

    fileprivate var switchRows = Section<SwitchCellData>(title: "", items: [])
    fileprivate var actionRows = Section<MenuAction>(title: "", items: [])
}


extension AnalysisOptionsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.setNeedsUpdate()
        switchCellSource.register(in: tableView)
        actionCellSource.register(in: tableView)
    }
}


extension AnalysisOptionsViewController {
    @objc fileprivate func switchValueChanged(_ sender: UISwitch) {
        viewModel?.toggleSwitch(atIndex: sender.tag)
        delegate?.analysisOptionsViewControllerSettingsChanged(self)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension AnalysisOptionsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return switchRows.items.count
        case 1: return actionRows.items.count
        default: return 0
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1: // actions
            actionRows.items[indexPath.row].perform(sender: self)

        default:
            break
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // switch cells
            let cell = switchCellSource.dequeue(from: tableView, for: indexPath, with: switchRows.items[indexPath.row])
            (cell.accessoryView as? UISwitch)?.tag = indexPath.row
            return cell

        case 1: // action cells
            return actionCellSource.dequeue(from: tableView, for: indexPath, with: actionRows.items[indexPath.row])

        default:
            assertionFailure()
            return UITableViewCell()
        }
    }


    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            switch indexPath.section {
            case 1: // action cells
                return actionRows.items[indexPath.row].relatedActions.map({ menuAction in
                    UITableViewRowAction(menuAction, sender: self)
                })

            default:
                return nil
            }
    }
}
