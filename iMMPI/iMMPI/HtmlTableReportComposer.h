//
//  HtmlTableReportComposer.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 05.10.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HtmlTableReportComposerDataSource;

@protocol HtmlTableReportComposer <NSObject>
@property (nonatomic, weak) id<HtmlTableReportComposerDataSource> dataSource;

- (NSString *)composeReport;

@end



@protocol HtmlTableReportComposerDataSource<NSObject>

@end