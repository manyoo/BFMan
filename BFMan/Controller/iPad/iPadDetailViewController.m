//
//  iPadDetailViewController.m
//  BFMan
//
//  Created by  on 12-5-30.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "iPadDetailViewController.h"
#import "AsyncImageView.h"
#import "HuabaoPicture.h"
#import "ItemImg.h"
#import "ItemsListViewController.h"
#import "iPadBrowserViewController.h"
#import "TaobaokeItem.h"
#import "NSString+URLConvert.h"
#import "HuabaoAuctionInfo.h"
#import "BFManConstants.h"
#import "ImageMemCache.h"
#import <QuartzCore/QuartzCore.h>
#import "HuaBao.h"

@interface iPadDetailViewController (PrivateMethod)

- (void)displayCurrentImageNote;
- (void)displayCurrentAuctions;
- (void)focusOnPage:(NSInteger)p;

@end

@implementation iPadDetailViewController
@synthesize navBar;
@synthesize bigImageView;
@synthesize smallImageView;
@synthesize titleLabel;
@synthesize itemsInfoView;
@synthesize scrollView;
@synthesize noteLabel;
@synthesize images = _images;
@synthesize page;
@synthesize itemsDisplayedOnPage, itemInfoDisplaying;
@synthesize huabao, huabaoPictures, huabaoAuctions, subScrollViews;
@synthesize itemsViewController;
@synthesize smallImageViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.page = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[ImageMemCache sharedImageMemCache] clearCache];
}

- (void)setHuabao:(HuaBao *)ahuabao pictures:(NSArray *)pictures auctions:(NSDictionary *)auctions {
    self.huabao = ahuabao;
    self.huabaoPictures = pictures;
    self.huabaoAuctions = auctions;
    
    NSMutableArray *imgitems = [[NSMutableArray alloc] initWithCapacity:huabaoPictures.count];
    for (HuabaoPicture *hp in huabaoPictures) {
        ItemImg *img = [[ItemImg alloc] init];
        img.url = hp.picUrl;
        [imgitems addObject:img];
    }
    self.images = imgitems;
}

- (void)setup {
    int x = 0;
    self.subScrollViews = [[NSMutableArray alloc] initWithCapacity:self.images.count];
    for (id image in _images) {
        CGRect subScrollFrame = CGRectMake(x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:subScrollFrame];
        subScrollView.bounces = NO;
        subScrollView.bouncesZoom = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.minimumZoomScale = 1;
        subScrollView.maximumZoomScale = 1;
        subScrollView.delegate = self;
        
        CGRect imgFrame = CGRectMake(5, 5, subScrollFrame.size.width - 10, subScrollView.frame.size.height - 10);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image size:IMG_BIG andFrame:imgFrame];
        imgView.usedInPageControl = YES;
        
        imgView.tag = 101;
        
        x += scrollView.frame.size.width;
        
        [subScrollView addSubview:imgView];
        subScrollView.contentSize = subScrollFrame.size;
        
        [scrollView addSubview:subScrollView];
        [subScrollViews addObject:subScrollView];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
    
    self.noteLabel = [[UILabel alloc] init];
    noteLabel.lineBreakMode = UILineBreakModeWordWrap;
    noteLabel.textColor = [UIColor darkTextColor];
    noteLabel.font = [UIFont systemFontOfSize:16];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.numberOfLines = 0;
    
    [bigImageView addSubview:noteLabel];
    
    [self displayCurrentImageNote];
    [self displayCurrentAuctions];
    [self focusOnPage:page];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (huabao.titleShort) {
        navBar.topItem.title = huabao.titleShort;
    } else {
        navBar.topItem.title = huabao.title;
    }
        
    titleLabel.text = huabao.title;
    
    self.itemsDisplayedOnPage = -1;
    
    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    self.smallImageViewController = [[SmallImageViewController alloc] initWithNibName:@"SmallImageViewController" bundle:nil];
    smallImageViewController.pictures = huabaoPictures;
    CGRect f = smallImageView.frame;
    smallImageViewController.view.frame = CGRectMake(0, 0, f.size.width, f.size.height);
    smallImageViewController.delegate = self;
    [smallImageView addSubview:smallImageViewController.view];
    
    [smallImageViewController setSelectedPicture:page];
    
    [self setup];
}

- (void)viewDidUnload
{
    [self setBigImageView:nil];
    [self setSmallImageView:nil];
    [self setScrollView:nil];
    [self setNavBar:nil];
    [self setTitleLabel:nil];
    [self setItemsInfoView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.subScrollViews = nil;
    self.noteLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (UIView *v in subScrollViews) {
        [v removeFromSuperview];
    }
    [noteLabel removeFromSuperview];
    [self setup];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sscrollView {
    return [sscrollView.subviews objectAtIndex:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sscrollView {
    if (scrollView != sscrollView) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    self.page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self focusOnPage:page];
    [self displayCurrentImageNote];
    [self displayCurrentAuctions];
    
    [smallImageViewController setSelectedPicture:page];
}

- (void)displayPage:(NSInteger)pagee {
    [scrollView scrollRectToVisible:CGRectMake(pagee * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES]; 
}

- (void)displayCurrentImageNote {    
    HuabaoPicture *hbPic = [huabaoPictures objectAtIndex:page];
    NSString *note = hbPic.picNote;
    
    CGSize curSize = bigImageView.bounds.size;
    CGSize noteSize = [note sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(curSize.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    noteLabel.text = note;
    
    noteLabel.frame = CGRectMake(0, curSize.height - noteSize.height, curSize.width, noteSize.height);
}

- (void)displayCurrentAuctions {
    HuabaoPicture *picture = [huabaoPictures objectAtIndex:self.page];
    NSMutableArray *auc = [huabaoAuctions objectForKey:[NSString stringWithFormat:@"%@", picture.picId]];
    if (auc == nil) {
        return;
    }
    if (itemsDisplayedOnPage >= 0) {
        if (itemsDisplayedOnPage == page) {
            return;
        }
        [itemsViewController.view removeFromSuperview];
    }
    self.itemsViewController = [[ItemsListViewController alloc] initWithNibName:@"ItemsListViewController" bundle:nil];
    itemsViewController.delegate = self;
    itemsViewController.huabaoAuctions = auc;
    itemsViewController.huabaoPicture = picture;
    itemsViewController.usedInIpad = YES;
    
    CGRect f = itemsInfoView.frame;
    itemsViewController.view.frame = CGRectMake(0, 0, f.size.width, 200 * auc.count);
    [itemsInfoView addSubview:itemsViewController.view];
}

- (void)focusOnPage:(NSInteger)currentPage {
    int totalPages = subScrollViews.count;
    for (int i = 0; i < totalPages; ++i) {
        UIScrollView *sub = [subScrollViews objectAtIndex:i];
        AsyncImageView *imgView = (AsyncImageView *)[sub viewWithTag:101];
        if (abs(i - currentPage) < 3) {
            [imgView getImage];
        } else
            [imgView displayImage:[AsyncImageView cameraImage]];
    }
}

- (void)pictureSelected:(int)idx {
    self.page = idx;
    [self displayPage:page];
    [self focusOnPage:page];
    [self displayCurrentImageNote];
    [self displayCurrentAuctions];
}

- (void)openBrowser:(HuabaoAuctionInfo *)auc {
    iPadBrowserViewController *browser = [[iPadBrowserViewController alloc] initWithNibName:@"iPadBrowserViewController" bundle:nil];
    if (auc.tbkItem) {
        browser.itemUrl = auc.tbkItem.clickUrl;
    } else {
        browser.itemUrl = auc.auctionUrl;
    }
    [self presentModalViewController:browser animated:YES];
}

- (void)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
