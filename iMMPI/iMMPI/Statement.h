//
//  Statement.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Statement interface

/*! A concrete implementation of Statement protocol.
 */
@interface Statement : NSObject<Statement>

@property (copy,   nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger statementID;

@end
