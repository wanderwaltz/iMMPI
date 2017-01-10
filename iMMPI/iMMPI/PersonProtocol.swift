import Foundation

/// Encapsulates personal information of a person taking MMPI test.
///
/// Gender and the age group are relevant for selecting a proper questionnaire for the person.
@objc protocol PersonProtocol: NSObjectProtocol {
    /// Full name of a person.
    var name: String { get set }

    /// Gender of a person.
    var gender: Gender { get set }

    /// Age group of a person
    var ageGroup: AgeGroup { get set }
}


extension PersonProtocol {
    func makeCopy() -> Person {
        return Person(
            name: name,
            gender: gender,
            ageGroup: ageGroup
        )
    }
}
