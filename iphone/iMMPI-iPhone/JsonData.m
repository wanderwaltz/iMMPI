//
//  JsonData.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JsonData.h"

#pragma mark -
#pragma mark JsonData implementation

@implementation JsonData

#pragma mark -
#pragma mark Private

- (id) nilProofObject: (id) object
{
    if (object == nil) return [NSNull null];
    else return object;
}


- (id) nsNullProofObject: (id) object
{
    if ([object isKindOfClass: [NSNull class]]) return nil;
    else return object;
}


#pragma mark -
#pragma mark Property setters/getters

#pragma mark NSString

- (void) setString: (NSString *) string forKey: (NSString *) key
{
    [_jsonData setObject: [self nilProofObject: string] 
                  forKey: key];
}


- (NSString *) stringForKey: (NSString *) key
{
    return [self nsNullProofObject: 
            [_jsonData objectForKey: key]];
}

#pragma mark NSDate

- (void) setDate: (NSDate *) date forKey: (NSString *) key
{
    [_jsonData setObject: [self nilProofObject: date] 
                  forKey: key];
}


- (NSDate *) dateForKey: (NSString *) key
{
    return [self nsNullProofObject:
            [_jsonData objectForKey: key]];
}

#pragma mark NSUInteger

- (void) setUnsigned: (NSUInteger) integer forKey: (NSString *) key
{
    [_jsonData setObject: [NSNumber numberWithUnsignedInteger: integer] 
                  forKey: key];
}


- (NSUInteger) unsignedForKey: (NSString *) key
{
    return [[self nsNullProofObject:
             [_jsonData objectForKey: key]] unsignedIntegerValue];
}

#pragma mark NSArray

- (void) setArray: (NSArray *) array forKey: (NSString *) key
{
    id mutable = array;
    if (![mutable isKindOfClass: [NSMutableArray class]]) 
        mutable = [array mutableCopy];
    
    [_jsonData setObject: [self nilProofObject: mutable] 
                  forKey: key];
}

- (NSMutableArray *) arrayForKey: (NSString *) key
{
    id array = [self nsNullProofObject:
                [_jsonData objectForKey: key]];
    
    if (![array isKindOfClass: [NSMutableArray class]])
        array = [array mutableCopy];
    
    return array;
}


#pragma mark -
#pragma mark initialization methods

- (id) initWithData:(NSData *)data
{
    NSError *error = nil;
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [NSJSONSerialization JSONObjectWithData: data 
                                                    options: NSJSONReadingMutableLeaves 
                                                      error: &error];
    }
    
    if (error == nil)
    {
        return self;   
    }
    else
    {
        NSLog(@"Error decoding json data: %@", error);
        return nil;
    }
}


- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [NSMutableDictionary dictionary];
    }
    return self;
}


- (NSData *) serialize
{
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject: _jsonData 
                                                   options: NSJSONWritingPrettyPrinted 
                                                     error: &error];
     
     
    if (error != nil)
    {
        NSLog(@"Error encoding json data: %@", error);
        return nil;
    }
    else 
        return data;
}

@end
