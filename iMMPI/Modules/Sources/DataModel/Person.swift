import Foundation

/// Encapsulates personal information of a person taking MMPI test.
///
/// Gender and the age group are relevant for selecting a proper
/// questionnaire for the person.
public struct Person: Hashable {
    /// Full name of a person.
    public let name: String

    /// Gender of a person.
    public let gender: Gender

    /// Age group of a person
    public let ageGroup: AgeGroup

    public init(
        name: String = "",
        gender: Gender = .male,
        ageGroup: AgeGroup = .adult
    ) {
        self.name = name
        self.gender = gender
        self.ageGroup = ageGroup
    }
}
