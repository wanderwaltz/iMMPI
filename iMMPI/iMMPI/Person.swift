import Foundation

/// A concrete implementation of `PersonProtocol`.
final class Person: NSObject {
    var name: String = ""
    var gender: Gender = .male
    var ageGroup: AgeGroup = .adult
}


extension Person: PersonProtocol {}
