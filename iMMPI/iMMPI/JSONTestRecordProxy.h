//
//  JSONTestRecordProxy.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 13/02/14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordProxy interface

@interface JSONTestRecordProxy : NSObject<TestRecordProtocol>
@property (copy, nonatomic) NSString *personName;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *directory;
@property (copy, nonatomic) NSDate   *date;


+ (id) proxyForRecord: (id<TestRecordProtocol>) record
         withFileName: (NSString *) fileName
          inDirectory: (NSString *) directory;

@end
