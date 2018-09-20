import UIKit

struct ScreenDescriptor {
    let restorationIdentifier: String?

    init(restorationIdentifier: String?, maker: ViewControllerMaker) {
        self.restorationIdentifier = restorationIdentifier
        self.maker = maker
    }

    private let maker: ViewControllerMaker
}


extension ScreenDescriptor {
    func makeViewController(with context: ViewControllerFactoryContext) -> UIViewController {
        return maker.make(with: context)
    }
}


// MARK: restorable state
extension ScreenDescriptor {
    static let allRecords = ScreenDescriptor(
        restorationIdentifier: nil,
        maker: .allRecords
    )

    static let trash = ScreenDescriptor(
        restorationIdentifier: nil,
        maker: .trash
    )

    static func addRecord(_ record: Record) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .addRecord(record)
        )
    }

    static func editRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .editRecord(with: identifier)
        )
    }

    static func detailsForSingleRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .detailsForSingleRecord(with: identifier)
        )
    }

    static func detailsForMultipleRecords(with identifiers: [RecordIdentifier]) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .detailsForMultipleRecords(with: identifiers)
        )
    }

    static func analysisForRecords(with identifiers: [RecordIdentifier]) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .analysisForRecords(with: identifiers)
        )
    }

    static func answersInputForRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .answersInputForRecord(with: identifier)
        )
    }

    static func answersReviewForRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .answersReviewForRecord(with: identifier)
        )
    }
}


// MARK: non-restorable state
extension ScreenDescriptor {
    static func analysisOptions(with context: AnalysisMenuActionContext) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .analysisOptions(with: context)
        )
    }

    static func analysisReportsList(with context: AnalysisMenuActionContext) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .analysisReportsList(with: context)
        )
    }

    static func mailComposer(with message: EmailMessage) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .mailComposer(with: message)
        )
    }
}
