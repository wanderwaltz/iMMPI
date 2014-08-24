//
//  SegueSourceAnalyzerGroupDetailedInfo.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueSourceAnalyzerGroupDetailedInfo protocol

@protocol AnalyzerGroupDetailedInfoViewControllerDelegate;

@protocol SegueSourceAnalyzerGroupDetailedInfo <NSObject>
@required

- (id<AnalyzerGroupDetailedInfoViewControllerDelegate>) delegateForAnalyzerGroupDetailedInfoWithSender: (id) sender;

- (id<AnalyzerProtocol>) analyzerForDetailedInfoWithSender: (id) sender;
- (id<AnalyzerGroup>) analyzerGroupForDetailedInfoWithSender: (id) sender;
- (id<TestRecordProtocol>) recordForAnalyzerGroupDetailedInfoWithSender: (id) sender;

@end
