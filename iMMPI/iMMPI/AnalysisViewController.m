#if 0
@interface AnalysisViewController()
<UIPopoverControllerDelegate,
 AnalysisOptionsViewControllerDelegate,
 AnalyzerGroupDetailedInfoViewControllerDelegate,
 MFMailComposeViewControllerDelegate>
{
    Analyzer *_analyzer;
    NSMutableArray *_analyzerGroupIndices;
    
    AnalysisHTMLReportGenerator *_reportGenerator;
    
    
    NSDateFormatter *_dateFormatter;
    UIPopoverController *_analysisOptionsPopover;
}

@end


- (void) presentPrintingInterface
{
    UIPrintInteractionController *printController =
    [UIPrintInteractionController sharedPrintController];
    
    UIMarkupTextPrintFormatter *formatter =
    [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:
     [_reportGenerator composeOverallAnalysisReportForGroupIndices: _analyzerGroupIndices
                                                  filterNormValues: [AnalysisSettings shouldFilterAnalysisResults]]];
    
    printController.printFormatter = formatter;
    
    [printController presentFromBarButtonItem: self.navigationItem.rightBarButtonItem
                                     animated: YES
                            completionHandler:
     ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error)
     {
                                
    }];
}


- (void) presentEmailInterface
{
    MFMailComposeViewController *controller =
    [MFMailComposeViewController new];
    
    controller.mailComposeDelegate = self;
    
    NSString *personDateSuffix = [NSString stringWithFormat: @"%@ %@",
                                  self.record.person.name,
                                  [_dateFormatter stringFromDate: self.record.date]];
    
    [controller setToRecipients: @[___Default_Email_For_Sending_Reports]];
    [controller setSubject:
     [NSString stringWithFormat: ___FORMAT_Test_Results_Email_Header,
      personDateSuffix]];
    
    
    void (^attachFile)(NSString *htmlContents,
                       NSData   *data,
                       NSString *mimeType,
                       NSString *nameFormat) =
    
    ^(NSString *htmlContents,
      NSData   *data,
      NSString *mimeType,
      NSString *nameFormat)
    {
        if ((data == nil) && (htmlContents.length > 0))
        {
            data = [htmlContents dataUsingEncoding: NSUTF8StringEncoding];
        }
        
        if (data != nil)
        {
            NSString *fileName =
            TransliterateToLatin([NSString stringWithFormat: nameFormat,
                                  personDateSuffix]);
            
            [controller addAttachmentData: data
                                 mimeType: mimeType
                                 fileName: fileName];
        }
    };
    
    
    NSString *htmlBriefReport =
    [_reportGenerator
     composeOverallAnalysisReportForGroupIndices: _analyzerGroupIndices
                                filterNormValues: [AnalysisSettings shouldFilterAnalysisResults]];
    
    NSString *htmlFullReport =
    [_reportGenerator composeOverallAnalysisReportForGroupIndices: nil
                                                 filterNormValues: NO];
    
    NSData *jsonRecordData = [JSONTestRecordSerialization dataWithTestRecord: self.record];
    
    NSString *htmlAnswersReport = [_reportGenerator composeAnswersReport];
    
    NSString *htmlReliabilityReport =
    [_reportGenerator composeDetailedReportForGroupNamed:
     ___Group_Name_Reliability];
    
    NSString *mimeHTML = @"text/html; charset=utf-8";
    NSString *mimeJSON = @"application/json; charset=utf-8";
    
    attachFile(htmlBriefReport,       nil, mimeHTML, ___FORMAT_File_Name_Analysis_Report_Brief);
    attachFile(htmlFullReport,        nil, mimeHTML, ___FORMAT_File_Name_Analysis_Report_Full);
    attachFile(htmlAnswersReport,     nil, mimeHTML, ___FORMAT_File_Name_Answers);
    attachFile(htmlReliabilityReport, nil, mimeHTML, ___FORMAT_File_Name_Reliability_Report);
    
    attachFile(nil, jsonRecordData, mimeJSON, ___FORMAT_File_Name_JSON_Record_Backup);
    
    
    
    
    [self presentViewController: controller
                       animated: YES
                     completion: nil];
}



#pragma mark -
#pragma mark AnalysisOptionsViewControllerDelegate

- (void) analysisOptionsViewControllerSettingsChanged:
 (AnalysisOptionsViewController *) controller
{
    [self reloadData];
}


- (void) analysisOptionsViewControllerPrintOptionSelected:
 (AnalysisOptionsViewController *) controller
{
    [_analysisOptionsPopover dismissPopoverAnimated: YES];
     _analysisOptionsPopover = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentPrintingInterface];
    });
}


- (void) analysisOptionsViewControllerEmailOptionSelected:
 (AnalysisOptionsViewController *)controller
{
    [_analysisOptionsPopover dismissPopoverAnimated: YES];
     _analysisOptionsPopover = nil;
    
    [self presentEmailInterface];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController: (MFMailComposeViewController *) controller
           didFinishWithResult: (MFMailComposeResult) result
                         error: (NSError *) error
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)      tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSUInteger groupIndex = [_analyzerGroupIndices[indexPath.row] integerValue];
    
    id<AnalyzerGroup> group = [_analyzer groupAtIndex: groupIndex];
    
    if ([group canProvideDetailedInfo])
    {
        [self performSegueWithIdentifier: kSegueIDAnalyzerGroupDetailedInfo
                                  sender: group];
    }
    else
    {
        [tableView deselectRowAtIndexPath: indexPath
                                 animated: YES];
    }
}


#pragma mark -
#pragma mark AnalyzerGroupDetailedInfoViewControllerDelegate

- (void) analyzerGroudDetailedInfoViewControllerDidCancel: (AnalyzerGroupDetailedInfoViewController *) controller
{
    if (self.tableView.indexPathForSelectedRow != nil)
    {
        [self.tableView deselectRowAtIndexPath: self.tableView.indexPathForSelectedRow
                                      animated: YES];
    }
    
    [self dismissViewControllerAnimated: YES
                             completion: nil];
}

@end
#endif
