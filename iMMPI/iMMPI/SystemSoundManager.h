//
//  SystemSoundManager.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 6/19/13.
//  Copyright (c) 2013 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark SystemSoundManager interface

@interface SystemSoundManager : NSObject

/*! Caches the sound for reuse if needed; the cached sound will be released when sound manager gets deleted
 */
- (void) playSoundNamed: (NSString *) fileName;

@end
