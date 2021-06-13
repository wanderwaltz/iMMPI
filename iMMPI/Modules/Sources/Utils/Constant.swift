public enum Constant<T> {
    public static func value<Arg>(_ constant: T) -> (Arg) -> T {
        return { _ in constant }
    }

    public static func value<A, B>(_ constant: T) -> (A, B) -> T {
        return { _, _ in constant }
    }
}
