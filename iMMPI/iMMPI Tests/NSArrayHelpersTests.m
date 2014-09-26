//
//  NSArrayHelpersTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "NSArray+Helpers.h"

SPEC_BEGIN(NSArrayHelpersTests)

describe(@"map:", ^{
    it(@"should call the mapping block for each element of the array", ^{
        NSArray *expected_items = @[@1, @2, @3];
        NSMutableArray *actual_items = [[NSMutableArray alloc] init];
        
        [expected_items map:^id(id item) {
            [actual_items addObject: item];
            return nil;
        }];
        
        [[actual_items should] equal: expected_items];
    });
    
    
    it(@"should return an array consisting of all mapping block results", ^{
        NSArray *items = @[@1, @3, @5];

        NSArray *mapped_items = [items map:^id(NSNumber *num) {
            return @([num integerValue] * 2);
        }];
        
        [[mapped_items should] equal: @[@2, @6, @10]];
    });
    
    
    it(@"should skip nil values returned from the mapping block", ^{
        NSArray *items = @[@1, @2, @3, @4];
        
        NSArray *mapped_items = [items map:^id(NSNumber *num) {
            return ([num integerValue] % 2 == 0) ? num : nil;
        }];
        
        [[mapped_items should] equal: @[@2, @4]];
    });
    
    
    it(@"should return nil array for invalid block", ^{
        [[[@[@1, @2, @3] map: nil] should] beNil];
    });
});


describe(@"filter:", ^{
    it(@"should call the filter block for each element of the array", ^{
        NSArray *expected_items = @[@1, @2, @3];
        NSMutableArray *actual_items = [[NSMutableArray alloc] init];
        
        [expected_items filter:^BOOL(id item) {
            [actual_items addObject: item];
            return NO;
        }];
        
        [[actual_items should] equal: expected_items];
    });
    
    
    it(@"should remove items for which the filter block returned NO from the resulting array", ^{
        NSArray *items = @[@1, @2, @3, @4];
        
        NSArray *filtered_items = [items filter:^BOOL(NSNumber *num) {
            return ([num integerValue] % 2 == 0);
        }];
        
        [[filtered_items should] equal: @[@2, @4]];
    });
    
    
    it(@"should return nil array for invalid block", ^{
        [[[@[@1, @2, @3] filter: nil] should] beNil];
    });
});

SPEC_END

