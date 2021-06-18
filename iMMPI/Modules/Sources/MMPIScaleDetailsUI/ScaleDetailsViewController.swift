import UIKit
import MMPIRouting

public final class ScaleDetailsViewController: UIViewController, UsingRouting {
    public var viewModel: ScaleDetailsViewModel? {
        didSet { reloadData() }
    }

    private let logLabel = UILabel()

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

        logLabel.numberOfLines = 0
    }
}

extension ScaleDetailsViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        logLabel.frame = view.bounds
        logLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(logLabel)
    }

    func reloadData() {
        title = viewModel?.title

        guard let viewModel = viewModel else {
            return
        }

        logLabel.text = viewModel.computation.log.joined(separator: "\n")
    }
}

extension ScaleDetailsViewController {
    @objc private func cancelButtonAction(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}
