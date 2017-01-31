import Foundation

/// Encapsulates personal information of a person taking MMPI test.
///
/// Gender and the age group are relevant for selecting a proper questionnaire for the person.
final class Person {
    /// Full name of a person.
    var name: String

    /// Gender of a person.
    var gender: Gender

    /// Age group of a person
    var ageGroup: AgeGroup

    init(name: String, gender: Gender, ageGroup: AgeGroup) {
        self.name = name
        self.gender = gender
        self.ageGroup = ageGroup
    }

    convenience init() {
        self.init(name: "", gender: .male, ageGroup: .adult)
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


extension Person {
    func makeCopy() -> Person {
        return Person(
            name: name,
            gender: gender,
            ageGroup: ageGroup
        )
    }
}
