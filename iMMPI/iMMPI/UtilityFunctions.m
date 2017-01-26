//
//  UtilityFunctions.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 28.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "UtilityFunctions.h"

NSString *TransliterateToLatin(NSString *string)
{
    if (string.length > 0)
    {
        NSMutableString *mutable = [string mutableCopy];
        CFMutableStringRef mutableRef = (__bridge CFMutableStringRef)mutable;
        CFStringTransform(mutableRef, NULL, kCFStringTransformToLatin, false);
        CFStringTransform(mutableRef, NULL, kCFStringTransformStripCombiningMarks,  false);
        
        return [mutable copy] ?: @"";
    }
    else return @"";
}
