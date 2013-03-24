//
//  SegueSourceAnalyzeRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 08.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueSourceAnalyzeRecord protocol

@protocol SegueSourceAnalyzeRecord <NSObject>
@required

- (id<TestRecordProtocol>) recordForAnalysisWithSender:  (id) sender;
- (id<TestRecordStorage>)  storageForAnalysisWithSender: (id) sender;

@end
