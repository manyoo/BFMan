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

@implementation FullImageViewController
@synthesize scrollView;
@synthesize titleBar;
@synthesize images = _images;
@synthesize subScrollViews = _subScrollViews;
@synthesize page;
@synthesize titleBarOn;
@synthesize huabao, huabaoPictures, huabaoAuctions;

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

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
    self.titleBar.topItem.title = [NSString stringWithFormat:@"%d of %d", page + 1, [_images count]];

    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    self.subScrollViews = [[NSMutableArray alloc] initWithCapacity:[_images count]];
    
    int x = 0;

    for (id image in _images) {
        CGRect subScrollFrame = CGRectMake(x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:subScrollFrame];
        subScrollView.bounces = YES;
        subScrollView.bouncesZoom = YES;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.maximumZoomScale = 4;
        subScrollView.minimumZoomScale = 1;
        subScrollView.delegate = self;
        
        CGRect imgFrame = CGRectMake(0, 0, subScrollFrame.size.width, subScrollFrame.size.height);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image andFrame:imgFrame];
        [imgView enableTouch];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(imageViewDoubleTouched:)];
        doubleTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:doubleTap];
        
        if ([self respondsToSelector:@selector(presentingViewController)]) {
            // WE use this ugly method to test whether we are on iOS 5.
            // if so, we can detect one-tap and double-tap.
            UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(imageViewTouched:)];
            oneTap.numberOfTapsRequired = 1;
            [imgView addGestureRecognizer:oneTap];   
        }
                
        [imgView getImage];
        
        x += scrollView.frame.size.width;
        
        [subScrollView addSubview:imgView];
        subScrollView.contentSize = subScrollFrame.size;
        
        [scrollView addSubview:subScrollView];
        [self.subScrollViews addObject:subScrollView];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    //[self displayPage:page];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        
    int x = 0;

    for (UIScrollView *v in scrollView.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            CGRect subScrollFrame = CGRectMake(x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
            v.frame = subScrollFrame;
            
            CGRect imgFrame = CGRectMake(0, 0, subScrollFrame.size.width, subScrollFrame.size.height);
            AsyncImageView *imgView = [v.subviews objectAtIndex:0];
            imgView.frame = imgFrame;
            v.contentSize = imgFrame.size;
            
            x += scrollView.frame.size.width;   
        }
    }

    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    //[self displayPage:page];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
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
        }];
        self.titleBarOn = NO;
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleBar.alpha = 1.0;
        }];
        self.titleBarOn = YES;
    }
}

- (void)imageViewDoubleTouched:(id)sender {
    UIScrollView *scroll = [self.subScrollViews objectAtIndex:page];
    if (scroll.zoomScale == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            scroll.zoomScale = 2;
        }];
    } else if (scroll.zoomScale == 2) {
        [UIView animateWithDuration:0.3 animations:^{
            scroll.zoomScale = 4;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            scroll.zoomScale = 1;
        }];
    }
}

@end
