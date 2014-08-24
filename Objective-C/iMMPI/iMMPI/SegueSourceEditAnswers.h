//
//  SegueSourceEditAnswers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 1/8/13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark SegueSourceEditAnswers protocol

@protocol SegueSourceEditAnswers <NSObject>
@required

- (id<TestRecordProtocol>) testRecordToEditAnswersWithSender: (id) sender;
- (id<TestRecordStorage>)     storageToEditAnswersWithSender: (id) sender;

@end
