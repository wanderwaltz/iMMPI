import Foundation
import MessageUI

protocol ViewControllerFactoryContext {
    var storage: RecordStorage { get }
    var trashStorage: RecordStorage { get }

    var analysisSettings: AnalysisSettings { get }
    
    var analysisOptionsViewControllerDelegate: AnalysisOptionsViewControllerDelegate { get }
    var answersInputDelegate: AnswersInputDelegate { get }
    var editRecordViewControllerDelegate: EditRecordViewControllerDelegate { get }
    var mailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate { get }
    var reportListViewControllerDelegate: AnalysisReportsListViewControllerDelegate { get }
}
