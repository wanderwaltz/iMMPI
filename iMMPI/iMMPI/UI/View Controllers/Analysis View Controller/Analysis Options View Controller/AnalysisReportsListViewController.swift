import UIKit
import HTMLComposing

protocol AnalysisReportsListViewControllerDelegate: AnyObject {
    func analysisReportsList(_ controller: AnalysisReportsListViewController, didSelectReport html: Html)
}


final class AnalysisReportsListViewController: UITableViewController, UsingRouting {
    weak var delegate: AnalysisReportsListViewControllerDelegate?

    var result: AnalysisResult?
    var reportGenerators: [HtmlReportGenerator] = []

    fileprivate let cellSource = TableViewCellSource<HtmlReportGenerator>(
        style: .default,
        identifier: "com.immpi.cells.default",
        update: { cell, generator in
            cell.textLabel?.text = generator?.title ?? ""
            cell.accessoryType = .disclosureIndicator
    })
}


// MARK: - UITableViewDelegate
extension AnalysisReportsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let result = result else {
            return
        }

        let generator = reportGenerators[indexPath.row]
        let html = generator.generate(for: result)

        delegate?.analysisReportsList(self, didSelectReport: html)
    }
}


// MARK: - UITableViewDataSource
extension AnalysisReportsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportGenerators.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellSource.dequeue(from: tableView, for: indexPath, with: reportGenerators[indexPath.row])
    }
}
