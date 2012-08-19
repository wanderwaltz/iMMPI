//
//  test_Model.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "test_Model.h"

#pragma mark -
#pragma mark test_Model implementation

@implementation test_Model

#pragma mark -
#pragma mark test cases

- (void) test_Entity
{
    NSEntityDescription *description = [NSEntityDescription entityForName: @"Entity"
                                                   inManagedObjectContext: _coreData.mainContext];
    
    GHAssertNotNil(description, @"");
    
    NSAttributeDescription *stringAttribute =
    [[description attributesByName] objectForKey: @"stringAttribute"];
    
    NSAttributeDescription *dateAttribute =
    [[description attributesByName] objectForKey: @"dateAttribute"];
    
    NSAttributeDescription *boolAttribute =
    [[description attributesByName] objectForKey: @"boolAttribute"];
    
    GHAssertNotNil(stringAttribute, @"");
    GHAssertNotNil(  dateAttribute, @"");
    GHAssertNotNil(  boolAttribute, @"");
    
    GHAssertEquals(stringAttribute.attributeType, (NSAttributeType) NSStringAttributeType, @"");
    GHAssertEquals(  dateAttribute.attributeType, (NSAttributeType)   NSDateAttributeType, @"");
    GHAssertEquals(  boolAttribute.attributeType, (NSAttributeType)NSBooleanAttributeType, @"");
}

@end
