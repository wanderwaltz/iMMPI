//
//  Paths.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Paths.h"

NSURL *NSDocumentsDirectoryURL()
{
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory
                                                   inDomains: NSUserDomainMask] lastObject];
}