//
//  SegueDestinationListRecords.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueDestinationListRecords protocol

@protocol SegueDestinationListRecords <NSObject>
@required

- (void)setModelForListRecords:(id<MutableTableViewModel>)model NS_SWIFT_NAME(setModelForListRecords(_:));
- (void)setStorageForListRecords:(id<TestRecordStorage>)storage NS_SWIFT_NAME(setStorageForListRecords(_:));
- (void)setTitleForListRecords:(NSString *)title NS_SWIFT_NAME(setTitleForListRecords(_:));


@optional

- (void)setSelectedTestRecord:(id<TestRecordProtocol> _Nullable)testRecord NS_SWIFT_NAME(setSelectedTestRecord(_:));

@end

NS_ASSUME_NONNULL_END
