//
//  HtmlBuilder.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HtmlBuilder <NSObject>

- (BOOL)isOpen;

- (void)open;
- (NSString *)close;

- (void)addOpeningTag:(NSString *)tag attributes:(NSDictionary *)attributes;
- (void)addClosingTag:(NSString *)tag;
- (void)addText:(NSString *)text;

- (void)addTag:(NSString *)tag attributes:(NSDictionary *)attributes text:(NSString *)text;

@end
