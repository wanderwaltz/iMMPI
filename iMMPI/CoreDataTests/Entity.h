//
//  Entity.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma mark -
#pragma mark Entity interface

@interface Entity : NSManagedObject

#pragma mark attributes

@property (strong, nonatomic) NSString *stringAttribute;
@property (strong, nonatomic) NSDate     *dateAttribute;
@property (assign, nonatomic) BOOL        boolAttribute;

@end
