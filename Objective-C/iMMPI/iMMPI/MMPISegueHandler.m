//
//  MMPISegueHanlder.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "MMPISegueHandler.h"
#import <objc/message.h>


#pragma mark -
#pragma mark Constants

NSString * const kSegueIDEditAnswers  = @"com.immpi.segue.editAnswers";
NSString * const kSegueIDAnswersInput = @"com.immpi.segue.answersInput";

NSString * const kSegueIDAddRecord    = @"com.immpi.segue.addRecord";
NSString * const kSegueIDEditRecord   = @"com.immpi.segue.editRecord";
NSString * const kSegueIDEditGroup    = @"com.immpi.segue.editGroup";

NSString * const kSegueIDBlankDetail  = @"com.immpi.segue.blankDetail";

NSString * const kSegueIDListGroup    = @"com.immpi.segue.listGroup";
NSString * const kSegueIDViewTrash    = @"com.immpi.segue.viewTrash";

NSString * const kSegueIDAnalyzer     = @"com.immpi.segue.analyzer";

NSString * const kSegueIDAnalyzerGroupDetailedInfo = @"com.immpi.segue.analyzerGroupDetailedInfo";


#pragma mark -
#pragma mark MMPISegueHandler private

@interface MMPISegueHandler()
{
    NSDictionary *_registeredSelectors;
}

@end


#pragma mark -
#pragma mark MMPISegueHandler implementation

@implementation MMPISegueHandler

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _registeredSelectors = @{
        kSegueIDEditAnswers  : @"handleEditAnswers:sender:",
        kSegueIDAnswersInput : @"handleEditAnswers:sender:",
        
        kSegueIDAddRecord    : @"handleEditRecord:sender:",
        kSegueIDEditRecord   : @"handleEditRecord:sender:",
        kSegueIDEditGroup    : @"handleEditRecord:sender:",
        
        kSegueIDBlankDetail  : @"doNothing:sender:",
        
        kSegueIDListGroup    : @"handleListRecords:sender:",
        kSegueIDViewTrash    : @"handleListRecords:sender:",
        
        kSegueIDAnalyzer     : @"handleAnalyzeRecord:sender:",
        
        kSegueIDAnalyzerGroupDetailedInfo : @"handleAnalyzerGroupDetailedInfo:sender:"
        };
    }
    return self;
}


#pragma mark -
#pragma mark SegueHandler

- (BOOL) canHandleSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    return _registeredSelectors[segue.identifier] != nil;
}


- (void) handleSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    id destination = SelfOrFirstChild(segue.destinationViewController);
    
    if ([destination conformsToProtocol: @protocol(StoryboardManagedViewControllerProtocol)])
    {
        [destination setSegueHandler: [self segueHandlerForManagedViewController: destination
                                                                           segue: segue
                                                                          sender: sender]];
    }
    
    
    NSString *selectorName = _registeredSelectors[segue.identifier];
    FRB_AssertNotNil(selectorName);
    
    SEL selector = NSSelectorFromString(selectorName);
    FRB_AssertResponds(self, selector);
    
    objc_msgSend(self, selector, segue, sender);
}


- (id<SegueHandler>) segueHandlerForManagedViewController: (id<StoryboardManagedViewControllerProtocol>) controller
                                                    segue: (UIStoryboardSegue *) segue
                                                   sender: (id) sender
{
    return self;
}


#pragma mark -
#pragma mark Segue Edit Answers

- (void) doNothing: (UIStoryboardSegue *) segue sender: (id) sender
{
    // This method does nothing and is reserved for segues which do not need
    // any special processing.
}


- (void) handleEditAnswers: (UIStoryboardSegue *) segue sender: (id) sender
{
    id<SegueSourceEditAnswers>      source      = (id)SelfOrFirstChild(segue.sourceViewController);
    id<SegueDestinationEditAnswers> destination = (id)SelfOrFirstChild(segue.destinationViewController);
    
    FRB_AssertConformsTo(source,      SegueSourceEditAnswers);
    FRB_AssertConformsTo(destination, SegueDestinationEditAnswers);
    
    [destination setRecordToEditAnswers:  [source testRecordToEditAnswersWithSender: sender]];
    [destination setStorageToEditAnswers: [source    storageToEditAnswersWithSender: sender]];
}


- (void) handleEditRecord: (UIStoryboardSegue *) segue sender: (id) sender
{
    id<SegueSourceEditRecord>      source      = (id)SelfOrFirstChild(segue.sourceViewController);
    id<SegueDestinationEditRecord> destination = (id)SelfOrFirstChild(segue.destinationViewController);
    
    FRB_AssertConformsTo(source,      SegueSourceEditRecord);
    FRB_AssertConformsTo(destination, SegueDestinationEditRecord);
    
    id<TestRecordProtocol> record = [source testRecordToEditWithSender: sender];
    
    [destination setTestRecordToEdit:             record];
    [destination setDelegateForEditingTestRecord: [source delegateForEditingTestRecordWithSender: sender]];
    [destination setTitleForEditingTestRecord:    [source titleForEditingTestRecord: record
                                                                         withSender: sender]];
}


- (void) handleListRecords: (UIStoryboardSegue *) segue sender: (id) sender
{
    id<SegueSourceListRecords>      source      = (id)SelfOrFirstChild(segue.sourceViewController);
    id<SegueDestinationListRecords> destination = (id)SelfOrFirstChild(segue.destinationViewController);
    
    FRB_AssertConformsTo(source,      SegueSourceListRecords);
    FRB_AssertConformsTo(destination, SegueDestinationListRecords);
    
    [destination setModelForListRecords:   [source modelForListRecordsWithSender:   sender]];
    [destination setStorageForListRecords: [source storageForListRecordsWithSender: sender]];
    [destination setTitleForListRecords:   [source titleForListRecordsWithSender:   sender]];
    
    
    if ([source respondsToSelector: @selector(selectedTestRecordForListRecordsWithSender:)] &&
        [destination respondsToSelector: @selector(setSelectedTestRecord:)])
    {
        [destination setSelectedTestRecord:
         [source selectedTestRecordForListRecordsWithSender: sender]];
    }
}


- (void) handleAnalyzeRecord: (UIStoryboardSegue *) segue sender: (id) sender
{
    id<SegueSourceAnalyzeRecord>      source      = (id)SelfOrFirstChild(segue.sourceViewController);
    id<SegueDestinationAnalyzeRecord> destination = (id)SelfOrFirstChild(segue.destinationViewController);
    
    FRB_AssertConformsTo(source,      SegueSourceAnalyzeRecord);
    FRB_AssertConformsTo(destination, SegueDestinationAnalyzeRecord);
    
    [destination setRecordForAnalysis:  [source recordForAnalysisWithSender:  sender]];
    [destination setStorageForAnalysis: [source storageForAnalysisWithSender: sender]];
}


- (void) handleAnalyzerGroupDetailedInfo: (UIStoryboardSegue *) segue sender: (id) sender
{
    id<SegueSourceAnalyzerGroupDetailedInfo>      source      = (id)SelfOrFirstChild(segue.sourceViewController);
    id<SegueDestinationAnalyzerGroupDetailedInfo> destination = (id)SelfOrFirstChild(segue.destinationViewController);
    
    FRB_AssertConformsTo(source,      SegueSourceAnalyzerGroupDetailedInfo);
    FRB_AssertConformsTo(destination, SegueDestinationAnalyzerGroupDetailedInfo);
    
    [destination setDelegateForAnalyzerGroupDetailedInfo:
     [source delegateForAnalyzerGroupDetailedInfoWithSender: sender]];
    
    [destination setAnalyzerGroupForDetailedInfo:
     [source analyzerGroupForDetailedInfoWithSender: sender]];
    
    [destination setRecordForAnalyzerGroupDetailedInfo:
     [source recordForAnalyzerGroupDetailedInfoWithSender: sender]];
    
    [destination setAnalyzerForDetailedInfo:
     [source analyzerForDetailedInfoWithSender: sender]];
}

@end
