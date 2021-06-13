import UIKit

/// A class for producing nonoptional `View` instances updated with a certain type of `Data`.
public struct ReusableViewSource<Container, View: UIView, Data> {
    /// Initializes a `ReusableViewSource`.
    ///
    /// - Parameters:
    ///    - register: a closure for registering the view source in a certain `Container`.
    ///    - rc:           container to regsiter the view source in.
    ///    - dequeue: a closure for dequeueing a reusable view from the given container
    ///               and updating it with the data provided.
    ///    - dc:           container to dequeue a view from.
    ///    - ip:           `IndexPath` to dequeue the reusable view for.
    ///    - data:         data to update view with.
    init(
        register: @escaping (_ rc: Container) -> (),
        dequeue: @escaping (_ dc: Container, _ ip: IndexPath, _ data: Data?) -> View
    ) {
        _register = register
        _dequeue = dequeue
    }

    fileprivate let _register: (Container) -> ()
    fileprivate let _dequeue: (Container, IndexPath, Data?) -> View
}


extension ReusableViewSource {
    /// Registers the view source in the given container.
    ///
    /// Uses the `register` closure with which the view source has been initialized.
    ///
    /// - Parameter container: container to register the view source in.
    public func register(in container: Container) {
        _register(container)
    }

    /// Dequeues a view from the given container and updates it with optional `Data`.
    ///
    /// Uses the `dequeue` closure with which the view source has been initialized.
    ///
    /// - Parameters:
    ///    - container: container to dequeue the view from,
    ///    - data:      data to update the view with.
    ///
    /// - Returns: the dequeued view. Since dequeueing the view is performed using
    ///            the closure provided in the `init` method, the actual logic
    ///            depends completely on the closure provided. `ReusableViewSource`
    ///            does not know by itself whether the view are actually being reused,
    ///            or created each time `dequeue` is called.
    public func dequeue(
        from container: Container,
        for indexPath: IndexPath,
        with data: Data?
    ) -> View {
        return _dequeue(container, indexPath, data)
    }
}
