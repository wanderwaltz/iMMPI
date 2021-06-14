import Foundation
import MMPIAnalysisUI

extension MMPIRouter {
    final class AnalysisOptionsDelegate {}
}


extension MMPIRouter.AnalysisOptionsDelegate: AnalysisOptionsViewControllerDelegate {
    func analysisOptionsViewControllerSettingsChanged(_ controller: AnalysisOptionsViewController) {
        NotificationCenter.default.post(name: .analysisSettingsChanged, object: nil)
    }
}
