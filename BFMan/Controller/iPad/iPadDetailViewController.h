//
//  iPadDetailViewController.h
//  BFMan
//
//  Created by  on 12-5-30.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallImageViewController.h"

@class ItemsListViewController;
@class HuaBao;

@interface iPadDetailViewController : UIViewController <UIScrollViewDelegate, SmallImageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *bigImageView;
@property (weak, nonatomic) IBOutlet UIView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *itemsInfoView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *subScrollViews;
@property (nonatomic) int page;
@property (nonatomic) BOOL itemInfoDisplaying;
@property (nonatomic) NSInteger itemsDisplayedOnPage;
@property (nonatomic, strong) HuaBao *huabao;
@property (nonatomic, strong) NSArray *huabaoPictures;
@property (nonatomic, strong) NSDictionary *huabaoAuctions;
@property (nonatomic, strong) ItemsListViewController *itemsViewController;
@property (nonatomic, strong) SmallImageViewController *smallImageViewController;

- (void)setHuabao:(HuaBao *)huabao pictures:(NSArray *)pictures auctions:(NSDictionary *)auctions;
- (void)displayPage:(NSInteger)page;
- (IBAction)cancel:(id)sender;

@end
