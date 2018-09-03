import Foundation

/// Encapsulates personal information of a person taking MMPI test.
///
/// Gender and the age group are relevant for selecting a proper questionnaire for the person.
struct Person {
    /// Full name of a person.
    let name: String

    /// Gender of a person.
    let gender: Gender

    /// Age group of a person
    let ageGroup: AgeGroup

    init(name: String = "", gender: Gender = .male, ageGroup: AgeGroup = .adult) {
        self.name = name
        self.gender = gender
        self.ageGroup = ageGroup
    }
}


extension Person: Hashable {
    var hashValue: Int {
        return name.hash ^ gender.hashValue ^ ageGroup.hashValue
    }


    static func == (left: Person, right: Person) -> Bool {
        return left.name == right.name
            && left.gender == right.gender
            && left.ageGroup == right.ageGroup
    }
}
