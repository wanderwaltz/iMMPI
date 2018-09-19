import Foundation
@testable import iMMPI

extension RecordIndexItem {
    func makeProxy() -> RecordProxy {
        return RecordProxy(indexItem: self, materialize: {
            var record = Record()

            record.date = self.date
            record.person = Person(
                name: self.personName,
                gender: .male,
                ageGroup: .adult
            )

            return record
        })
    }
}
