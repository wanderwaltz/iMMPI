//
//  main.m
//  CoreDataTests
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    int retVal = 0;
    
    @autoreleasepool
    {
        retVal = UIApplicationMain(argc, argv, nil,
                                   NSStringFromClass([GHUnitIOSAppDelegate class]));
    }
    
    return retVal;
}
