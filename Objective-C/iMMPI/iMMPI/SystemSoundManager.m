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
#import <AVFoundation/AVFoundation.h>


#pragma mark -
#pragma mark SystemSoundManager private

@interface SystemSoundManager()<AVAudioPlayerDelegate>
{
@private
    NSMutableSet *_players;
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
        _players = [NSMutableSet set];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) playSoundNamed: (NSString *) fileName
{
    NSParameterAssert(fileName.length > 0);
    
    NSURL *fileURL =
    [[NSBundle mainBundle] URLForResource: [fileName stringByDeletingPathExtension]
                            withExtension: [fileName pathExtension]];
    
    if (fileURL != nil)
    {
        NSError        *error = nil;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                                                       error: &error];
        
        if (error == nil)
        {
            player.delegate = self;
            [player play];
            [_players addObject: player];
        }
        else
        {
            NSLog(@"FAILED to play sound '%@' with error: %@", fileName, error);
        }
    }
}


#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) flag
{
    [_players removeObject: player];
}

@end
