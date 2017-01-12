#if 0
//
//  AnalysisViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"
#import "Model.h"


#pragma mark -
#pragma mark AnalysisViewController interface

@interface AnalysisViewController : StoryboardManagedTableViewController
<SegueSourceEditAnswers,
 SegueSourceAnalyzerGroupDetailedInfo,
 SegueDestinationAnalyzeRecord>

@property (strong, nonatomic) id<TestRecordProtocol> record;


/*! AnalysisViewController does not use the storage itself, but forwards it to the TestAnswersViewController if editing answers option is selected.
 */
@property (strong, nonatomic) id<TestRecordStorage>  storage;

@end
#endif
