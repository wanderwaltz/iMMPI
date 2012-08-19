//
//  NSManagedObject+Insertion.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <CoreData/CoreData.h>

#pragma mark -
#pragma mark NSManagedObject+Insertion interface

@interface NSManagedObject (Insertion)

+ (id) insertInContext: (NSManagedObjectContext *) context;

+ (NSString *) entityName; // Defaults to the class name

@end
