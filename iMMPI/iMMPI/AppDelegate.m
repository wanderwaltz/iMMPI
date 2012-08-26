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
    CoreDataStack         *coreData = [Model coreData];
    NSManagedObjectContext *context = coreData.mainContext;
    
    [coreData do:^{
       
        Person *person = nil;
        
        person = [Person insertInContext: context];
        person.firstName      = @"Александр";
        person.patronymicName = @"Александрович";
        person.lastName       = @"Блок";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Николай";
        person.patronymicName = @"Васильевич";
        person.lastName       = @"Гоголь";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Александр";
        person.patronymicName = @"Сергеевич";
        person.lastName       = @"Грибоедов";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Федор";
        person.patronymicName = @"Михайлович";
        person.lastName       = @"Достоевский";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Сергей";
        person.patronymicName = @"Александрович";
        person.lastName       = @"Есенин";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Михаил";
        person.patronymicName = @"Юрьевич";
        person.lastName       = @"Лермонтов";
        
        person = [Person insertInContext: context];
        person.firstName      = @"Николай";
        person.patronymicName = @"Алексеевич";
        person.lastName       = @"Некрасов";
        
        [coreData saveMainContext];
    }];
}

@end
