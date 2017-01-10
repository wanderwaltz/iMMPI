//
//  MMPISegueHanlder.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Storyboard.h"

#pragma mark -
#pragma mark protocols

// Edit/Input Answers
#import "SegueSourceEditAnswers.h"
#import "SegueDestinationEditAnswers.h"


// Analysing a TestRecordProtocol object
#import "SegueSourceAnalyzeRecord.h"
#import "SegueDestinationAnalyzeRecord.h"


// Getting detailed info on a certain analyzer group
#import "SegueSourceAnalyzerGroupDetailedInfo.h"
#import "SegueDestinationAnalyzerGroupDetailedInfo.h"


#pragma mark -
#pragma mark Constants

/* Protocols required to be adopted by the source and destination view controllers for the corresponding segue to be handled properly are shown in comments near the segue ID constant.
 */
extern NSString * const kSegueIDEditAnswers;  // SegueSourceEditAnswers, SegueDestinationEditAnswers
extern NSString * const kSegueIDAnswersInput; // SegueSourceEditAnswers, SegueDestinationEditAnswers

extern NSString * const kSegueIDBlankDetail;  // No protocols required

extern NSString * const kSegueIDAnalyzer;     // SegueSourceAnalyzeRecord, SegueDestinationAnalyzeRecord

extern NSString * const kSegueIDAnalyzerGroupDetailedInfo; // SegueSourceAnalyzerGroupDetailedInfo, SegueDestinationAnalyzerGroupDetailedInfo


#pragma mark -
#pragma mark MMPISegueHandler intreface

@interface MMPISegueHandler : NSObject<SegueHandler>
@end
