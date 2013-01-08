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

// Edit/Add Test Record
#import "SegueSourceEditRecord.h"
#import "SegueDestinationEditRecord.h"

// Listing TestRecordProtocol objects
#import "SegueSourceListRecords.h"
#import "SegueDestinationListRecords.h"


#pragma mark -
#pragma mark Constants

/* Protocols required to be adopted by the source and destination view controllers for the corresponding
   segue to be handled properly are shown in comments near the segue ID constant.
 */
extern NSString * const kSegueIDEditAnswers;  // SegueSourceEditAnswers, SegueDestinationEditAnswers
extern NSString * const kSegueIDAnswersInput; // SegueSourceEditAnswers, SegueDestinationEditAnswers

extern NSString * const kSegueIDAddRecord;    // SegueSourceEditRecord,  SegueDestinationEditRecord
extern NSString * const kSegueIDEditRecord;   // SegueSourceEditRecord,  SegueDestinationEditRecord
extern NSString * const kSegueIDEditGroup;    // SegueSourceEditRecord,  SegueDestinationEditRecord

extern NSString * const kSegueIDBlankDetail;  // No protocols required

extern NSString * const kSegueIDListGroup;    // SegueSourceListRecords,  SegueDestinationListRecords
extern NSString * const kSegueIDViewTrash;    // SegueSourceListRecords,  SegueDestinationListRecords


#pragma mark -
#pragma mark MMPISegueHandler intreface

@interface MMPISegueHandler : NSObject<SegueHandler>
@end
