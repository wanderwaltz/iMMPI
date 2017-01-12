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

NSString * const kSegueIDBlankDetail  = @"com.immpi.segue.blankDetail";
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
        kSegueIDBlankDetail  : @"doNothing:sender:",
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
    
    void (*segueHandler)(id, SEL, UIStoryboardSegue *, id) = (void(*)(id, SEL, UIStoryboardSegue *, id))objc_msgSend;
    segueHandler(self, selector, segue, sender);
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
