//
//  JSONTestRecordModelElement.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordModelElement interface

@interface JSONTestRecordModelElement : NSObject

@property (strong, nonatomic) id<TestRecord> record;
@property (strong, nonatomic) NSString *fileName;

@end
