//
//  FullImageViewController.h
//  Pazar
//
//  Created by  on 11-8-24.
//  Copyright 2011 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuaBao;
@class ItemsListViewController;

@interface FullImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *subScrollViews;
@property (nonatomic) int page;
@property (nonatomic) BOOL titleBarOn;
@property (nonatomic) NSInteger itemsDisplayedOnPage;
@property (nonatomic, strong) HuaBao *huabao;
@property (nonatomic, strong) NSArray *huabaoPictures;
@property (nonatomic, strong) NSDictionary *huabaoAuctions;
@property (nonatomic, strong) ItemsListViewController *itemsViewController;

- (void)displayPage:(NSInteger)page;
- (IBAction)cancel:(id)sender;

@end
