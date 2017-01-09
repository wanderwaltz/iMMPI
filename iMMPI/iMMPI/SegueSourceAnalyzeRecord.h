//
//  SegueSourceAnalyzeRecord.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 08.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueSourceAnalyzeRecord protocol

@protocol SegueSourceAnalyzeRecord<NSObject>
@required

- (id<TestRecordProtocol> _Nullable)recordForAnalysisWithSender:(id _Nullable)sender
NS_SWIFT_NAME(recordForAnalysis(with:));

- (id<TestRecordStorage> _Nullable)storageForAnalysisWithSender:(id _Nullable)sender
NS_SWIFT_NAME(storageForAnalysis(with:));

@end

NS_ASSUME_NONNULL_END
