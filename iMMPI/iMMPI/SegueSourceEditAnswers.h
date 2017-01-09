//
//  SegueSourceEditAnswers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark SegueSourceEditAnswers protocol

@protocol SegueSourceEditAnswers<NSObject>
@required

- (id<TestRecordProtocol> _Nullable)testRecordToEditAnswersWithSender:(id _Nullable)sender
NS_SWIFT_NAME(testRecordToEditAnswers(with:));

- (id<TestRecordStorage> _Nullable)storageToEditAnswersWithSender:(id _Nullable)sender
NS_SWIFT_NAME(storageToEditAnswers(with:));

@end

NS_ASSUME_NONNULL_END
