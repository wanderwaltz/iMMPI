//
//  AppDelegate.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AppDelegate.h"


#pragma mark -
#pragma mark AppDelegate implementation

@implementation AppDelegate

#pragma mark -
#pragma mark application lifecycle

         - (BOOL) application: (UIApplication *) application
didFinishLaunchingWithOptions: (NSDictionary  *) launchOptions
{
    [Model  setupCoreData];
    [self insertDebugData];
    
    return YES;
}


- (void) applicationWillTerminate: (UIApplication *) application
{
    [Model tearDownCoreData];
}


#pragma mark -
#pragma mark private: debug info

- (void) insertDebugData
{
    CoreDataStack *coreData = [Model coreData];
    
    [coreData do:^{
       
        NSManagedObjectContext *context = coreData.mainContext;
        Person *person = nil;
        
        person = [Person insertInContext: context];
        person.firstName = @"Глеб";
        person.lastName  = @"Соколов";
        
        [coreData saveMainContext];
    }];
}

@end
