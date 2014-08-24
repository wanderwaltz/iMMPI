//
//  SegueDestinationEditAnswers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueDestinationEditAnswers protocol

@protocol SegueDestinationEditAnswers <NSObject>
@required

- (void) setRecordToEditAnswers:  (id<TestRecordProtocol>) record;
- (void) setStorageToEditAnswers: (id<TestRecordStorage>) storage;

@end
