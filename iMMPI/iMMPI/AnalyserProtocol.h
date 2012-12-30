//
//  AnalyserProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 30.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark Analyser protocol

@protocol Analyser<NSObject>
@required

- (id<AnalyserGroup>) firstGroupForType: (NSString *) type;

- (BOOL) isValidStatementID: (NSInteger) statementID;

@end
