//
//  SystemSoundManager.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 6/19/13.
//  Copyright (c) 2013 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "SystemSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>


#pragma mark -
#pragma mark SystemSoundManager private

@interface SystemSoundManager()
{
@private
    NSMutableDictionary *_systemSoundIDs;
}

@end


#pragma mark -
#pragma mark SystemSoundManager implementation

@implementation SystemSoundManager

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _systemSoundIDs = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void) dealloc
{
    [_systemSoundIDs enumerateKeysAndObjectsUsingBlock:
     ^(id key, NSNumber *number, BOOL *stop) {
         NSNumber *soundIDNumber = number;
         
         if (soundIDNumber != nil)
         {
             AudioServicesDisposeSystemSoundID([soundIDNumber unsignedIntValue]);
         }
    }];
}


#pragma mark -
#pragma mark methods

- (void) playSoundNamed: (NSString *) fileName
{
    if (fileName.length > 0)
    {
        NSNumber *existingSound = _systemSoundIDs[fileName];
        
        if (existingSound == nil)
        {
            NSString *resourcePath =
            [[NSBundle mainBundle] pathForResource: [fileName stringByDeletingPathExtension]
                                            ofType: [fileName pathExtension]];
            
            SystemSoundID soundID = 0;
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: resourcePath],
                                             &soundID);
            
            existingSound = @(soundID);
            
            _systemSoundIDs[fileName] = existingSound;
        }
        
        AudioServicesPlaySystemSound([existingSound unsignedIntValue]);
    }
}

@end
