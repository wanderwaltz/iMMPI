import Foundation

/// A concrete implementation of `PersonProtocol`.
final class Person: NSObject {
    var name: String
    var gender: Gender
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


extension Person: PersonProtocol {}


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
