import Foundation
import DataModel

struct JSONPersonSerialization {
    let ageGroup: JSONAgeGroupSerialization
    let gender: JSONGenderSerialization

    init(ageGroup: JSONAgeGroupSerialization = JSONAgeGroupSerialization(),
         gender: JSONGenderSerialization = JSONGenderSerialization()) {
        self.ageGroup = ageGroup
        self.gender = gender
    }
}


extension JSONPersonSerialization {
    enum Key {
        static let name = "name"
        static let gender = "gender"
        static let ageGroup = "ageGroup"
    }
}


extension JSONPersonSerialization {
    func encode(_ person: Person) -> [String:Any] {
        return [
            Key.name: person.name,
            Key.gender: gender.encode(person.gender),
            Key.ageGroup: ageGroup.encode(person.ageGroup)
        ]
    }


    func decode(_ value: Any?) -> Person? {
        guard let json = value as? [String:Any], let name = json[Key.name] as? String else {
            return nil
        }

        return Person(
            name: name,
            gender: gender.decode(json[Key.gender]),
            ageGroup: ageGroup.decode(json[Key.ageGroup])
        )
    }
}
