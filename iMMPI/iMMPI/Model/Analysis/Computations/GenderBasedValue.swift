import Foundation
import DataModel

/// A wrapper simplifying processing of gender-based properties, i.e. properties,
/// which value may be different depending on the person's gender.
///
/// For example, median values for some of the analysis scales are different
/// for men and women.
struct GenderBasedValue<T> {
    /// Initializes a `GenderBasedValue` with two possible values: one corresponding to `Gender.male`,
    /// another corresponding to `Gender.female`.
    ///
    /// - Parameters:
    ///    - male:   a value of type `T` corresponding to `Gender.male`,
    ///    - female: a value of type `T` corresponding to `Gender.female`.
    init(male: T, female: T) {
        self.male = male
        self.female = female
    }

    fileprivate let male: T
    fileprivate let female: T
}

extension GenderBasedValue {
    /// - Returns: the stored value corresponding to the `gender` provided.
    ///
    /// - Parameter gender: a `Gender` instance corresponding to the desired value.
    ///                     `Gender.unknown` values fallback to `Gender.male`.
    func value(for gender: Gender) -> T {
        switch gender {
        case .female: return female
        case .male: return male
        case .unknown: return male
        }
    }

    /// A shorthand method for getting gender-based value for a test record.
    ///
    /// - Returns: the stored value corresponding to the `record.person.gender`.
    ///
    /// - Parameter record: a `RecordProtocol` instance corresponding to the desired value.
    ///                    `Gender.unknown` values fallback to `Gender.male`.
    func value(for record: RecordProtocol) -> T {
        return value(for: record.person.gender)
    }
}

extension GenderBasedValue {
    /// - Returns: a `GenderBasedValue` providing distinct values for different genders.
    ///
    /// - Parameters:
    ///    - male:   a value of type `T` corresponding to `Gender.male`,
    ///    - female: a value of type `T` corresponding to `Gender.female`.
    static func specific(male: T, female: T) -> GenderBasedValue {
        return GenderBasedValue(male: male, female: female)
    }

    /// - Returns: a `GenderBasedValue` providing distinct values for different genders.
    ///
    /// - Parameters:
    ///    - block:  a closure, which returns a value of type `T` based on the provided `Gender`.
    ///    - gender: a `Gender` instance corresponding to the desired value.
    static func specific(_ block: (_ gender: Gender) -> T) -> GenderBasedValue {
        return GenderBasedValue(male: block(.male), female: block(.female))
    }

    /// - Returns: a `GenderBasedValue` providing the same value for different genders.
    ///
    /// - Parameter value: a value of type `T` corresponding to both genders.
    static func common(_ value: T) -> GenderBasedValue {
        return GenderBasedValue(male: value, female: value)
    }
}
