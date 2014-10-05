//
//  HtmlBuilderTests.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "Kiwi.h"

#import "DefaultHtmlBuilder.h"

SPEC_BEGIN(DefaultHtmlBuilderTests)

describe(@"DefaultHtmlBuilder", ^{
    it(@"should conform to <HtmlBuilder> protocol", ^{
        [[[DefaultHtmlBuilder class] should] conformToProtocol: @protocol(HtmlBuilder)];
    });
    
    
    context(@"when newly created", ^{
        let(builder, ^DefaultHtmlBuilder *{
            return [[DefaultHtmlBuilder alloc] init];
        });
        
        
        it(@"should return empty string when opening and closing the html without adding any content", ^{
            [builder open];
            [[[builder close] should] equal: @""];
        });
        
        
        it(@"should return nil when trying to close html without opening it first", ^{
            [[[builder close] should] beNil];
        });
        
        
        it(@"should be closed by default", ^{
            [[theValue([builder isOpen]) should] beFalse];
        });
        

        it(@"should change the -isOpen value when opening", ^{
            [builder open];
            [[theValue([builder isOpen]) should] beTrue];
        });
    });
    
    
    context(@"when being open", ^{
        let(builder, ^DefaultHtmlBuilder *{
            return [[DefaultHtmlBuilder alloc] init];
        });
        
        beforeEach(^{
            [builder open];
        });
        
        it(@"should add opening tag to html string when asked to", ^{
            [builder addOpeningTag: @"some_tag" attributes: nil];
            [[[builder close] should] equal: @"<some_tag>"];
        });
        
        
        it(@"should add closing tag to html string when asked to", ^{
            [builder addClosingTag: @"some_tag"];
            [[[builder close] should] equal: @"</some_tag>"];
        });
        
        it(@"should add attributes to opening html tag when asked to", ^{
            [builder addOpeningTag: @"some_tag" attributes: @{ @"attr1" : @"value1", @"attr2" : @"value2" }];
            [[[builder close] should] equal: @"<some_tag attr1=\"value1\" attr2=\"value2\">"];
        });
        
        
        it(@"should add text to the html string when asked to", ^{
            [builder addText: @"some_text"];
            [[[builder close] should] equal: @"some_text"];
        });
        
        
        it(@"should add opening tag, text and closing tag to html when asked to", ^{
            NSString *tag = @"some_tag";
            NSDictionary *attributes = @{ @"attr1" : @"value1", @"attr2" : @"value2" };
            NSString *text = @"text";
            [[builder should] receive: @selector(addOpeningTag:attributes:) withArguments: tag, attributes];
            [[builder should] receive: @selector(addText:) withArguments: text];
            [[builder should] receive: @selector(addClosingTag:) withArguments: tag];
            [builder addTag: tag attributes: attributes text: text];
        });
        
        
        it(@"should open and close the tag in one block if there is no text", ^{
            [builder addTag: @"some_tag" attributes: nil text: nil];
            [[[builder close] should] equal: @"<some_tag/>"];
        });
        
        
        it(@"should open and close the tag with attributes in one block if there is no text", ^{
            [builder addTag: @"some_tag" attributes: @{ @"attr1" : @"value1", @"attr2" : @"value2" } text: nil];
            [[[builder close] should] equal: @"<some_tag attr1=\"value1\" attr2=\"value2\"/>"];
        });
        
        
        it(@"should discard the current html string when reopening", ^{
            [builder addText: @"some_text"];
            [builder open];
            [builder addText: @"other_text"];
            [[[builder close] should] equal: @"other_text"];
        });
        
        
        it(@"should discard the current html string when closing", ^{
            [builder addText: @"some_text"];
            [[[builder close] should] equal: @"some_text"];
            [[[builder close] should] beNil];
        });
    });
});

SPEC_END

