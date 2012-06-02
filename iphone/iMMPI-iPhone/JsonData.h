//
//  JsonData.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Serializable.h"

#pragma mark -
#pragma mark JsonData interface

@interface JsonData : NSObject<Serializable>
{
    NSMutableDictionary *_jsonData;
}

#pragma mark property setters/getters

// NSString
- (void) setString: (NSString *) string forKey: (NSString *) key;
- (NSString *) stringForKey: (NSString *) key;

// NSDate
- (void) setDate: (NSDate *) date forKey: (NSString *) key;
- (NSDate *) dateForKey: (NSString *) key;

// NSUInteger
- (void) setUnsigned: (NSUInteger) integer forKey: (NSString *) key;
- (NSUInteger) unsignedForKey: (NSString *) key;

// NSArray
- (void) setArray: (NSArray *) array forKey: (NSString *) key;
- (NSMutableArray *) arrayForKey: (NSString *) key;

@end
