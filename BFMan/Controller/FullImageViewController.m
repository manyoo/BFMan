//
//  FullImageViewController.m
//  Pazar
//
//  Created by  on 11-8-24.
//  Copyright 2011 Manyoo Studio. All rights reserved.
//

#import "FullImageViewController.h"
#import "AsyncImageView.h"
#import "HuabaoPicture.h"
#import "ItemImg.h"
#import "ItemsListViewController.h"
#import "TaobaoBrowserViewController.h"
#import "TaobaokeItem.h"
#import "NSString+URLConvert.h"
#import "HuabaoAuctionInfo.h"
#import "BFManConstants.h"
#import "ImageMemCache.h"

@interface FullImageViewController (PrivateMethod)
- (void)displayCurrentImageNote;
- (void)focusOnPage:(NSInteger)currentPage;
@end

@implementation FullImageViewController
@synthesize scrollView;
@synthesize titleBar;
@synthesize noteLabel;
@synthesize images = _images;
@synthesize page;
@synthesize titleBarOn, itemsDisplayedOnPage, itemInfoDisplaying;
@synthesize huabao, huabaoPictures, huabaoAuctions, subScrollViews;
@synthesize itemsViewController, tagButton, arrowButton,upArrowImage, downArrowImage,displayingSmallPictures;
@synthesize smallImageViewController, zoomScale;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.upArrowImage = [UIImage imageNamed:@"up_arrow.png"];
        self.downArrowImage = [UIImage imageNamed:@"down_arrow.png"];
        
        self.displayingSmallPictures = NO;
        self.page = 0;
        self.zoomScale = 1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    self.titleBarOn = YES;
    self.itemsDisplayedOnPage = -1;
    self.titleBar.topItem.title = [NSString stringWithFormat:@"%d of %d", page + 1, [_images count]];
    
    self.tagButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cart.png"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(tagButtonTapped:)];
    HuabaoPicture *picture = [huabaoPictures objectAtIndex:self.page];
    NSMutableArray *auc = [huabaoAuctions objectForKey:[NSString stringWithFormat:@"%@", picture.picId]];
    if (auc != nil) {
        self.titleBar.topItem.rightBarButtonItem = tagButton;
    } else {
        self.titleBar.topItem.rightBarButtonItem = nil;
    }
    
    self.itemInfoDisplaying = NO;

    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    int x = 0;

    self.subScrollViews = [[NSMutableArray alloc] initWithCapacity:self.images.count];
    for (id image in _images) {
        CGRect subScrollFrame = CGRectMake(x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:subScrollFrame];
        subScrollView.bounces = NO;
        subScrollView.bouncesZoom = YES;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.minimumZoomScale = 1;
        subScrollView.maximumZoomScale = 4;
        subScrollView.delegate = self;
        
        CGRect imgFrame = CGRectMake(0, 0, subScrollFrame.size.width, subScrollFrame.size.height);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image size:IMG_BIG andFrame:imgFrame];
        [imgView enableTouch];
        

        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewDoubleTapped:)];
        twoTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:twoTap];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewTouched:)];
        oneTap.numberOfTapsRequired = 1;
        [oneTap requireGestureRecognizerToFail:twoTap];
        [imgView addGestureRecognizer:oneTap];

        
        //[imgView getImage];
        imgView.tag = 101;
        
        x += scrollView.frame.size.width;
        
        [subScrollView addSubview:imgView];
        subScrollView.contentSize = subScrollFrame.size;
        
        [scrollView addSubview:subScrollView];
        [self.subScrollViews addObject:subScrollView];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    //[self displayPage:page];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
    
    self.noteLabel = [[UILabel alloc] init];
    noteLabel.lineBreakMode = UILineBreakModeWordWrap;
    noteLabel.textColor = [UIColor whiteColor];
    noteLabel.font = [UIFont systemFontOfSize:14];
    noteLabel.backgroundColor = [UIColor blackColor];
    noteLabel.numberOfLines = 0;
    
    [self.view addSubview:noteLabel];
    
    [self displayCurrentImageNote];
    [self focusOnPage:page];
    
    self.smallImageViewController = [[SmallImageViewController alloc] initWithNibName:@"SmallImageViewController" bundle:nil];
    smallImageViewController.pictures = huabaoPictures;
    smallImageViewController.view.frame = CGRectMake(0, 480, 320, 72);
    smallImageViewController.delegate = self;
    [self.view addSubview:smallImageViewController.view];
    
    CGRect f = self.view.frame;
    self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(f.size.width - 20, f.size.height, 15, 15)];
    [arrowButton setImage:upArrowImage forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:arrowButton];
    
    if (!displayingSmallPictures) {
        CGSize curSize = self.view.bounds.size;
        smallImageViewController.view.frame = CGRectMake(0, curSize.height + 20, curSize.width, 88);
        CGRect noteFrame = noteLabel.frame;
        noteLabel.frame = CGRectMake(noteFrame.origin.x, noteFrame.origin.y + 20, noteFrame.size.width, noteFrame.size.height);
        CGRect btnFrame = arrowButton.frame;
        arrowButton.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y, btnFrame.size.width, btnFrame.size.height);
        [arrowButton setImage:upArrowImage forState:UIControlStateNormal];
    } else {
        CGSize curSize = self.view.bounds.size;
        smallImageViewController.view.frame = CGRectMake(0, curSize.height - 68, curSize.width, 88);
        CGRect noteFrame = noteLabel.frame;
        noteLabel.frame = CGRectMake(noteFrame.origin.x, noteFrame.origin.y + 20, noteFrame.size.width, noteFrame.size.height);
        CGRect btnFrame = arrowButton.frame;
        arrowButton.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y - 88, btnFrame.size.width, btnFrame.size.height);
        [arrowButton setImage:downArrowImage forState:UIControlStateNormal];
    }
    [smallImageViewController setSelectedPicture:page];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTitleBar:nil];
    self.subScrollViews = nil;
    self.tagButton = nil;
    self.noteLabel = nil;
    self.arrowButton = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sscrollView {
    return [sscrollView.subviews objectAtIndex:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVieww {
    if (scrollView != scrollVieww) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    self.page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.titleBar.topItem.title = [NSString stringWithFormat:@"%d of %d", page + 1, [_images count]];
    if (titleBarOn) {
        [self displayCurrentImageNote];
    }
    [self focusOnPage:page];
    
    [smallImageViewController setSelectedPicture:page];
    
    HuabaoPicture *picture = [huabaoPictures objectAtIndex:self.page];
    NSMutableArray *auc = [huabaoAuctions objectForKey:[NSString stringWithFormat:@"%@", picture.picId]];
    if (auc != nil) {
        self.titleBar.topItem.rightBarButtonItem = tagButton;
    } else {
        self.titleBar.topItem.rightBarButtonItem = nil;
    }
}

- (void)displayPage:(NSInteger)pagee {
    [scrollView scrollRectToVisible:CGRectMake(pagee * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES]; 
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imageViewTouched:(id)sender {
    if (titleBarOn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleBar.alpha = 0.0;
            self.noteLabel.alpha = 0.0;
            arrowButton.alpha = 0.0;
        }];
        self.titleBarOn = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleBar.alpha = 1.0;
            self.noteLabel.alpha = 0.7;
            arrowButton.alpha = 1.0;
        }];
        self.titleBarOn = YES;
        [self displayCurrentImageNote];
    }
}

- (void)imageViewDoubleTapped:(id)sender {
    UIScrollView *subScroll = [subScrollViews objectAtIndex:page];
    if (zoomScale == 1) {
        self.zoomScale = 2;
        subScroll.zoomScale = 2;
    } else if (zoomScale == 2) {
        self.zoomScale = 4;
        subScroll.zoomScale = 4;
    } else {
        self.zoomScale = 1;
        subScroll.zoomScale = 1;
    }
}

- (void)tagButtonTapped:(id)sender {
    if (itemInfoDisplaying) {
        self.itemInfoDisplaying = NO;
        if (itemsDisplayedOnPage < 0 || itemsDisplayedOnPage != page) {
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            itemsViewController.view.frame = CGRectMake(0, 480, 320, 0);
            itemsViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [itemsViewController.view removeFromSuperview];
            self.itemsViewController = nil;
        }];
        itemsDisplayedOnPage = -1;
    } else {
        self.itemInfoDisplaying = YES;
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
        UIScrollView *subScrollView = [subScrollViews objectAtIndex:self.page];
        [subScrollView addSubview:itemsViewController.view];
        
        itemsViewController.view.frame = CGRectMake(0, 480, 320, 80 * auc.count);
        itemsViewController.view.alpha = 0;
        
        itemsDisplayedOnPage = page;
        
        [UIView animateWithDuration:0.5 animations:^{
            itemsViewController.view.frame = CGRectMake(0, 100, 320, 80 * auc.count);
            itemsViewController.view.alpha = 1;
        }];   
    }
}

- (void)openBrowser:(HuabaoAuctionInfo *)auc {
    HuabaoPicture *picture = [huabaoPictures objectAtIndex:self.page];
    NSMutableArray *aucs = [huabaoAuctions objectForKey:[NSString stringWithFormat:@"%@", picture.picId]];
    if (aucs.count == 1) {
        self.itemInfoDisplaying = NO;
        [UIView animateWithDuration:0.5 animations:^{
            itemsViewController.view.frame = CGRectMake(0, 480, 320, 0);
            itemsViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [itemsViewController.view removeFromSuperview];
            self.itemsViewController = nil;
        }];
        itemsDisplayedOnPage = -1;
    }
    TaobaoBrowserViewController *browser = [[TaobaoBrowserViewController alloc] initWithNibName:@"TaobaoBrowserViewController" bundle:nil];
    TaobaokeItem *item = auc.tbkItem;
    if (item) {
        NSString *newUrl = [item.clickUrl newClickUrlForItemId:item.itemID];
        if (newUrl) {
            browser.itemUrl = newUrl;
        } else {
            browser.itemUrl = [NSString stringWithFormat:@"%@&ttid=%@", item.clickUrl, TAOBAO_TTID_STR];
        }
        browser.picUrl = picture.picUrl;
        browser.itemId = item.itemID;
    } else {
        browser.picUrl = picture.picUrl;
        if (auc.auctionUrl == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"该商品无法打开"
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        } 
        browser.itemUrl = auc.auctionUrl;
        browser.itemId = auc.auctionId;
    }
    browser.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:browser animated:YES];
}

- (void)displayCurrentImageNote {    
    HuabaoPicture *hbPic = [huabaoPictures objectAtIndex:page];
    NSString *note = hbPic.picNote;
    
    CGSize curSize = self.view.bounds.size;
    CGSize noteSize = [note sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(curSize.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    noteLabel.text = note;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (displayingSmallPictures) {
            noteLabel.frame = CGRectMake(0, curSize.height - noteSize.height - 88, curSize.width, noteSize.height);
        } else {
            noteLabel.frame = CGRectMake(0, curSize.height - noteSize.height, curSize.width, noteSize.height);
        }
        noteLabel.alpha = 0.7;
    }];
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
    self.titleBar.topItem.title = [NSString stringWithFormat:@"%d of %d", page + 1, [_images count]];
    if (titleBarOn) {
        [self displayCurrentImageNote];
    }
}

- (void)arrowButtonTapped:(id)sender {
    if (displayingSmallPictures) {
        [UIView animateWithDuration:0.3 animations:^{
            CGSize curSize = self.view.bounds.size;
            smallImageViewController.view.frame = CGRectMake(0, curSize.height, curSize.width, 88);
            CGRect noteFrame = noteLabel.frame;
            noteLabel.frame = CGRectMake(noteFrame.origin.x, noteFrame.origin.y + 88, noteFrame.size.width, noteFrame.size.height);
            CGRect btnFrame = arrowButton.frame;
            arrowButton.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y + 88, btnFrame.size.width, btnFrame.size.height);
            [arrowButton setImage:upArrowImage forState:UIControlStateNormal];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGSize curSize = self.view.bounds.size;
            smallImageViewController.view.frame = CGRectMake(0, curSize.height - 88, curSize.width, 88);
            CGRect noteFrame = noteLabel.frame;
            noteLabel.frame = CGRectMake(noteFrame.origin.x, noteFrame.origin.y - 88, noteFrame.size.width, noteFrame.size.height);
            CGRect btnFrame = arrowButton.frame;
            arrowButton.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y - 88, btnFrame.size.width, btnFrame.size.height);
            [arrowButton setImage:downArrowImage forState:UIControlStateNormal];
        }];
    }
    self.displayingSmallPictures = !displayingSmallPictures;
}

@end
