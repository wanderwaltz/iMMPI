//
//  PersonRecordProtocol.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 5/24/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#pragma mark -
#pragma mark PersonRecordProtocol protocol

@protocol PersonRecordProtocol <NSObject>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString  *lastName;

@property (strong, nonatomic) NSDate *birthDate;

@end
