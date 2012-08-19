//
//  Person.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma mark -
#pragma mark Person interface

@interface Person : NSManagedObject

#pragma mark attributes

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *patronymicName;

@property (strong, nonatomic) NSDate *birthDate;

@end
