//
//  WebCollectionViewFooter.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark WebCollectionViewFooter interface

@interface WebCollectionViewFooter : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
