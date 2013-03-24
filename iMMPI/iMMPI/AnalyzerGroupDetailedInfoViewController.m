//
//  AnalyzerGroupDetailedInfoViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 24.03.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AnalyzerGroupDetailedInfoViewController.h"
#import "LabelCollectionViewCell.h"
#import "LabelCollectionViewHeader.h"
#import "WebCollectionViewFooter.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kCellID   = @"cell";
static NSString * const kHeaderID = @"header";
static NSString * const kFooterID = @"footer";

enum
{
    kSectionPositiveStatements,
    kSectionNegativeStatements,
    kSectionDetails
};


#pragma mark -
#pragma mark AnalyzerGroupDetailedInfoViewController private

@interface AnalyzerGroupDetailedInfoViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView *_collectionView;
    
    NSArray *_positiveStatementIDs;
    NSArray *_negativeStatementIDs;
}

@end



#pragma mark -
#pragma mark AnalyzerGroupDetailedInfoViewController implementation

@implementation AnalyzerGroupDetailedInfoViewController

#pragma mark -
#pragma mark actions

- (IBAction) cancelButtonAction: (id) sender
{
    if ([_delegate respondsToSelector: @selector(analyzerGroudDetailedInfoViewControllerDidCancel:)])
    {
        [_delegate analyzerGroudDetailedInfoViewControllerDidCancel: self];
    }
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = (id)_collectionView.collectionViewLayout;
    FRB_AssertClass(layout, UICollectionViewFlowLayout);
    
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing      = 1.0;
    
    _positiveStatementIDs = [self.analyzerGroup positiveStatementIDsForRecord: self.record];
    _negativeStatementIDs = [self.analyzerGroup negativeStatementIDsForRecord: self.record];
}


#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)       collectionView: (UICollectionView *) collectionView
                         layout: (UICollectionViewLayout*) collectionViewLayout
referenceSizeForFooterInSection: (NSInteger) section
{
    if (section == kSectionDetails)
    {
        return CGSizeMake(0.0, 200.0);
    }
    else
    {
        return CGSizeMake(0.0, 22.0);
    }
}


#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) collectionView
{
    return 3;
}

- (NSInteger) collectionView: (UICollectionView *) view
      numberOfItemsInSection: (NSInteger) section;
{
    switch (section)
    {
        case kSectionPositiveStatements: return _positiveStatementIDs.count; break;
        case kSectionNegativeStatements: return _negativeStatementIDs.count; break;
            
        default: return 0;
    }
}


- (UICollectionReusableView *) collectionView: (UICollectionView *) collectionView
            viewForSupplementaryElementOfKind: (NSString *) kind
                                  atIndexPath: (NSIndexPath *) indexPath
{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader])
    {
        LabelCollectionViewHeader *header =
        [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                           withReuseIdentifier: kHeaderID
                                                  forIndexPath: indexPath];
        FRB_AssertClass(header, LabelCollectionViewHeader);
        
        switch (indexPath.section)
        {
            case kSectionNegativeStatements:
            {
                header.label.text = ___Negative_Answers;
            } break;
                
            case kSectionPositiveStatements:
            {
                header.label.text = ___Positive_Answers;
            } break;
                
                
            case kSectionDetails:
            {
                header.label.text = ___Additional_Info;
            } break;
                
            default:
            {
                header.label.text = nil;
            } break;
        }
        
        return header;
    }
    else if ([kind isEqualToString: UICollectionElementKindSectionFooter])
    {
        if (indexPath.section == kSectionDetails)
        {
            WebCollectionViewFooter *footer =
            [collectionView dequeueReusableSupplementaryViewOfKind: kind
                                               withReuseIdentifier: kFooterID
                                                      forIndexPath: indexPath];
            FRB_AssertClass(footer, WebCollectionViewFooter);
            
            return footer;
        }
        else
        {
            return nil;
        }
    }
    else return nil;
}


- (UICollectionViewCell *) collectionView: (UICollectionView *) view
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath;
{
    LabelCollectionViewCell *cell =
    [view dequeueReusableCellWithReuseIdentifier: kCellID
                                    forIndexPath: indexPath];
    FRB_AssertClass(cell, LabelCollectionViewCell);
    
    switch (indexPath.section)
    {
        case kSectionNegativeStatements:
        {
            NSUInteger statementID = [_negativeStatementIDs[indexPath.row] unsignedIntegerValue];
            
            cell.label.text = [NSString stringWithFormat: @"%d", statementID];
            
            if ([self.record.testAnswers
                 answerTypeForStatementID: statementID] == AnswerTypeNegative)
            {
                cell.backgroundColor = [UIColor colorWithRed: 1.0
                                                       green: 0.5
                                                        blue: 0.5
                                                       alpha: 1.0];
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
            }
        } break;
            
        case kSectionPositiveStatements:
        {
            NSUInteger statementID = [_positiveStatementIDs[indexPath.row] unsignedIntegerValue];
            
            cell.label.text = [NSString stringWithFormat: @"%d", statementID];
            
            if ([self.record.testAnswers
                 answerTypeForStatementID: statementID] == AnswerTypePositive)
            {
                cell.backgroundColor = [UIColor colorWithRed: 0.5
                                                       green: 0.5
                                                        blue: 1.0
                                                       alpha: 1.0];
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
            }
        } break;
            
        default:
        {
            cell.label.text      = nil;
            cell.backgroundColor = [UIColor clearColor];
        } break;
    }
        
    return cell;
}



#pragma mark -
#pragma mark SegueDestinationAnalyzerGroupDetailedInfo

- (void) setDelegateForAnalyzerGroupDetailedInfo: (id<AnalyzerGroupDetailedInfoViewControllerDelegate>) delegate
{
    self.delegate = delegate;
}


- (void) setAnalyzerGroupForDetailedInfo: (id<AnalyzerGroup>) group
{
    self.analyzerGroup = group;
    self.title = group.name;
}


- (void) setRecordForAnalyzerGroupDetailedInfo: (id<TestRecordProtocol>) record
{
    self.record = record;
}

@end
