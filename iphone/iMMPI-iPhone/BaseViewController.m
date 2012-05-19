//
//  BaseViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "BaseViewController.h"

#pragma mark -
#pragma mark BaseViewController implementation

@implementation BaseViewController

#pragma mark -
#pragma mark View lifecycle

- (NSDictionary *) nibExternals
{
    return [NSDictionary dictionaryWithObject: self.navigationItem 
                                       forKey: @"Navigation Item"];
}


- (void) loadView
{
    NSBundle *bundle  = self.nibBundle;
    NSString *nibName = self.nibName;
    
    if (bundle == nil) bundle = [NSBundle mainBundle];
    
    if (nibName == nil)
    {
        nibName = NSStringFromClass([self class]);
        
        if ([bundle URLForResource: nibName withExtension: @"nib"] == nil) nibName = nil;
    }
    
    if (nibName != nil)
    {
        [bundle loadNibNamed: nibName 
                       owner: self 
                     options: 
         [NSDictionary dictionaryWithObject: [self nibExternals]   
                                     forKey: UINibExternalObjects]];
    }
    else [super loadView];
}

@end
