import UIKit
@testable import iMMPI

final class StubTableViewDataSource: NSObject {
    var _numberOfSections: (UITableView) -> Int = Constant.value(0)
    var _numberOfRows: (UITableView, Int) -> Int = Constant.value(0)
    var _cellForRow: (UITableView, IndexPath) -> UITableViewCell = { _ in UITableViewCell() }
}


extension StubTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return _numberOfSections(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfRows(tableView, section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _cellForRow(tableView, indexPath)
    }
}
