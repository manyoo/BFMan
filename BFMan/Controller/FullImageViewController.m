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
#import "AppDelegate.h"
#import "ItemsListViewController.h"
#import "TaobaoBrowserViewController.h"
#import "TaobaokeItem.h"
#import "NSString+URLConvert.h"

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
@synthesize titleBarOn, itemsDisplayedOnPage;
@synthesize huabao, huabaoPictures, huabaoAuctions, subScrollViews;
@synthesize itemsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }

    NSMutableArray *imgitems = [[NSMutableArray alloc] initWithCapacity:huabaoPictures.count];
    for (HuabaoPicture *hp in huabaoPictures) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        ItemImg *img = (ItemImg *)[NSEntityDescription insertNewObjectForEntityForName:@"ItemImg" inManagedObjectContext:context];
        img.url = hp.picUrl;
        [imgitems addObject:img];
    }
    self.images = imgitems;
    
    self.titleBarOn = YES;
    self.itemsDisplayedOnPage = -1;
    self.titleBar.topItem.title = [NSString stringWithFormat:@"%d of %d", page + 1, [_images count]];

    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    int x = 0;

    self.subScrollViews = [[NSMutableArray alloc] initWithCapacity:imgitems.count];
    for (id image in _images) {
        CGRect subScrollFrame = CGRectMake(x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:subScrollFrame];
        subScrollView.bounces = NO;
        subScrollView.bouncesZoom = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.minimumZoomScale = 1;
        subScrollView.delegate = self;
        
        CGRect imgFrame = CGRectMake(0, 0, subScrollFrame.size.width, subScrollFrame.size.height);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image andFrame:imgFrame];
        [imgView enableTouch];
        

        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewTouched:)];
        oneTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:oneTap];   
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(imageViewSwipedUp:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [imgView addGestureRecognizer:swipeUp];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(imageViewSwipedDown:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [imgView addGestureRecognizer:swipeDown];
        
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
    [self focusOnPage:0];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTitleBar:nil];
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
}

- (void)displayPage:(NSInteger)pagee {
    [scrollView scrollRectToVisible:CGRectMake(pagee * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
}


- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imageViewTouched:(id)sender {
    if (titleBarOn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleBar.alpha = 0.0;
            self.noteLabel.alpha = 0.0;
        }];
        self.titleBarOn = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleBar.alpha = 1.0;
            self.noteLabel.alpha = 0.7;
        }];
        self.titleBarOn = YES;
    }
}

- (void)imageViewSwipedUp:(id)sender {
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

- (void)imageViewSwipedDown:(id)sender {
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
}

- (void)openBrowser:(TaobaokeItem *)item {
    TaobaoBrowserViewController *browser = [[TaobaoBrowserViewController alloc] initWithNibName:@"TaobaoBrowserViewController" bundle:nil];
    browser.itemUrl = [item.clickUrl newClickUrlForItemId:item.itemID];
    browser.picUrl = item.picUrl;
    browser.itemId = item.itemID;
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
        noteLabel.frame = CGRectMake(0, curSize.height - noteSize.height, curSize.width, noteSize.height);
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

@end
