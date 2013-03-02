//
//  MMPIATestRecordReader.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 17.02.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Constants

extern NSString * const kMMPIATestRecordReaderDirectoryDefault;


#pragma mark -
#pragma mark MMPIATestRecordReader interface

@interface MMPIATestRecordReader : NSObject

@property (assign, atomic) BOOL isProcessingRecords;

- (id) initWithDirectoryName: (NSString *) storageDirectoryName;

- (void) readRecordFilesInBackgroundWithCallback:
            (void (^)(id<TestRecordProtocol> record, NSString *fileName,
                      NSUInteger totalFiles, NSUInteger recordsRead)) callback
                                      completion:
            (void (^)(NSUInteger filesProcessed, NSUInteger recordsRead)) completion;

@end
