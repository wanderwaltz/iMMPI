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
        restorationIdentifier:
            ScreenDescriptorSerialization
                .RestorationIdentifier
                .allRecords,
        maker:
            .allRecords
    )

    static let trash = ScreenDescriptor(
        restorationIdentifier:
            ScreenDescriptorSerialization
                .RestorationIdentifier
                .trash,
        maker:
            .trash
    )

    static func editRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier:
                ScreenDescriptorSerialization
                    .RestorationIdentifier
                    .editRecord(with: identifier),
            maker:
                .editRecord(with: identifier)
        )
    }

    static func detailsForMultipleRecords(with identifiers: [RecordIdentifier]) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier:
                ScreenDescriptorSerialization
                    .RestorationIdentifier
                    .detailsForMultipleRecords(with: identifiers),
            maker:
                .detailsForMultipleRecords(with: identifiers)
        )
    }

    static func analysisForRecords(with identifiers: [RecordIdentifier]) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier:
                ScreenDescriptorSerialization
                    .RestorationIdentifier
                    .analysisForRecords(with: identifiers),
            maker:
                .analysisForRecords(with: identifiers)
        )
    }

    static func answersInputForRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier:
                ScreenDescriptorSerialization
                    .RestorationIdentifier
                    .answersInputForRecord(with: identifier),
            maker:
                .answersInputForRecord(with: identifier)
        )
    }

    static func answersReviewForRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier:
                ScreenDescriptorSerialization
                    .RestorationIdentifier
                    .answersReviewForRecord(with: identifier),
            maker:
                .answersReviewForRecord(with: identifier)
        )
    }
}


// MARK: non-restorable state
extension ScreenDescriptor {
    // `addRecord` is not restorable since we don't want to store the Record which not yet has been saved:
    // it will be more difficult than just storing record id inside the restoration identifier.
    static func addRecord(_ record: Record) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .addRecord(record)
        )
    }

    // `detailsForSingleRecord` is not restorable since this 'screen' does not actually exists as a separate
    // entity: it will be resolved into either analysis or answers input, which are restored separately.
    // This is an implementation detail.
    static func detailsForSingleRecord(with identifier: RecordIdentifier) -> ScreenDescriptor {
        return ScreenDescriptor(
            restorationIdentifier: nil,
            maker: .detailsForSingleRecord(with: identifier)
        )
    }

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
