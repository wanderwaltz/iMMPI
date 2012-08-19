//
//  Model.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"

#pragma mark -
#pragma mark Model interface

@interface Model : NSObject
{
    CoreDataStack *_coreData;
}

+ (CoreDataStack *) coreData;

+ (void) setupCoreData;
+ (void) tearDownCoreData;

@end
