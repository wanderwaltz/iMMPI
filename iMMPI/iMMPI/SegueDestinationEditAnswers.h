//
//  SegueDestinationEditAnswers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueDestinationEditAnswers protocol

@protocol SegueDestinationEditAnswers <NSObject>
@required

- (void)setRecordToEditAnswers:(id<TestRecordProtocol>)record NS_SWIFT_NAME(setRecordToEditAnswers(_:));
- (void)setStorageToEditAnswers:(id<TestRecordStorage>)storage NS_SWIFT_NAME(setStorageToEditAnswers(_:));

@end

NS_ASSUME_NONNULL_END
