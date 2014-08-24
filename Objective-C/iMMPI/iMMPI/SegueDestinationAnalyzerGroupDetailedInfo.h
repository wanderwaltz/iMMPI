//
//  SegueDestinationAnalyzerGroupDetailedInfo.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

#pragma mark -
#pragma mark SegueDestinationAnalyzerGroupDetailedInfo protocol

@protocol AnalyzerGroupDetailedInfoViewControllerDelegate;

@protocol SegueDestinationAnalyzerGroupDetailedInfo <NSObject>
@required

- (void) setDelegateForAnalyzerGroupDetailedInfo: (id<AnalyzerGroupDetailedInfoViewControllerDelegate>) delegate;

- (void) setAnalyzerForDetailedInfo: (id<AnalyzerProtocol>) analyzer;
- (void) setAnalyzerGroupForDetailedInfo: (id<AnalyzerGroup>) group;
- (void) setRecordForAnalyzerGroupDetailedInfo: (id<TestRecordProtocol>) record;

@end
