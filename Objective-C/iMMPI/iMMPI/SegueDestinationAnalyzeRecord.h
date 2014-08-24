//
//  SegueDestinationAnalyzeRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 08.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueDestinationAnalyzeRecord protocol

@protocol SegueDestinationAnalyzeRecord <NSObject>
@required

- (void) setRecordForAnalysis:  (id<TestRecordProtocol>) record;
- (void) setStorageForAnalysis: (id<TestRecordStorage>)  storage;

@end
