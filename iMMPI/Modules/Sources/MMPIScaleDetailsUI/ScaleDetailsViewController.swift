import UIKit
import MMPIRouting

public final class ScaleDetailsViewController: UIViewController, UsingRouting {
    public var viewModel: ScaleDetailsViewModel? {
        didSet { reloadData() }
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonAction(_:))
        )
    }
}

extension ScaleDetailsViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    func reloadData() {
        title = viewModel?.title
    }
}

extension ScaleDetailsViewController {
    @objc private func cancelButtonAction(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}
