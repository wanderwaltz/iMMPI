//
//  NSManagedObject+Insertion.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "NSManagedObject+Insertion.h"

#pragma mark -
#pragma mark NSManagedObject+Insertion

@implementation NSManagedObject (Insertion)

+ (id) insertInContext: (NSManagedObjectContext *) context
{
    return [NSEntityDescription insertNewObjectForEntityForName: [self entityName]
                                         inManagedObjectContext: context];
}


+ (NSString *) entityName
{
    return NSStringFromClass([self class]);
}

@end
