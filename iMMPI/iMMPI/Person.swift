import Foundation

/// Encapsulates personal information of a person taking MMPI test.
///
/// Gender and the age group are relevant for selecting a proper questionnaire for the person.
final class Person: NSObject {
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

    convenience override init() {
        self.init(name: "", gender: .male, ageGroup: .adult)
    }
}


extension Person {
    override var hash: Int {
        return name.hash ^ gender.hashValue ^ ageGroup.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let person = object as? Person else {
            return false
        }

        return name == person.name
            && gender == person.gender
            && ageGroup == person.ageGroup
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
