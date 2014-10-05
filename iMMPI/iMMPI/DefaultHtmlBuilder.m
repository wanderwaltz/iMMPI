//
//  DefaultHtmlBuilder.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "DefaultHtmlBuilder.h"

#define FAIL_IF_HTML_STRING_NOT_INITIALIZED                                        \
    NSAssert(self.html != nil, @"Html string not initialized. Call -open first."); \
    if (!self.html) {                                                              \
        return;                                                                    \
    }


@interface DefaultHtmlBuilder()
@property (nonatomic, strong) NSMutableString *html;
@end

@implementation DefaultHtmlBuilder

#pragma mark -
#pragma mark <HtmlBuilder>

- (BOOL)isOpen
{
    return (self.html != nil);
}

- (void)open
{
    self.html = [[NSMutableString alloc] init];
}


- (NSString *)close
{
    NSString *result = [self.html copy];
    self.html = nil;
    return result;
}


- (void)addOpeningTag:(NSString *)tag attributes:(NSDictionary *)attributes
{
    [self addOpeningTag: tag attributes: attributes closeImmediately: NO];
}


- (void)addClosingTag:(NSString *)tag
{
    FAIL_IF_HTML_STRING_NOT_INITIALIZED;
    [self.html appendFormat: @"</%@>", tag];
}


- (void)addText:(NSString *)text
{
    FAIL_IF_HTML_STRING_NOT_INITIALIZED;
    [self.html appendString: text];
}


- (void)addTag:(NSString *)tag attributes:(NSDictionary *)attributes text:(NSString *)text
{
    FAIL_IF_HTML_STRING_NOT_INITIALIZED;
    
    if (text.length > 0) {
        [self addOpeningTag: tag attributes: attributes];
        [self addText: text];
        [self addClosingTag: tag];
    }
    else {
        [self addOpeningTag: tag attributes: attributes closeImmediately: YES];
    }
}


#pragma mark -
#pragma mark private

- (void)addOpeningTag:(NSString *)tag attributes:(NSDictionary *)attributes closeImmediately:(BOOL)close
{
    FAIL_IF_HTML_STRING_NOT_INITIALIZED;
    NSString *formattedAttributes = [self formatAttributes: attributes];
    
    if (formattedAttributes.length > 0) {
        [self.html appendFormat: @"<%@ %@", tag, formattedAttributes];
    }
    else {
        [self.html appendFormat: @"<%@", tag];
    }
    
    if (close) {
        [self.html appendString: @"/"];
    }

    [self.html appendString: @">"];
}


- (NSString *)formatAttributes:(NSDictionary *)attributes
{
    NSMutableArray *attributePairs = [[NSMutableArray alloc] initWithCapacity: attributes.count];
    
    [attributes enumerateKeysAndObjectsUsingBlock:^(id attribute, id value, BOOL *stop) {
        NSString *formattedAttribute = [NSString stringWithFormat: @"%@=\"%@\"", [attribute description], [value description]];
        [attributePairs addObject: formattedAttribute];
    }];
    
    return [attributePairs componentsJoinedByString: @" "];
}

@end
