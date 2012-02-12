//
//  HelpPhotoViewController.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-11.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "HelpPhotoViewController.h"

@implementation HelpPhotoViewController
@synthesize titleBar;
@synthesize pageControll;
@synthesize scrollView, page, images, titleBarOn;

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

    self.images = [NSArray arrayWithObjects:[UIImage imageNamed:@"help1.png"], [UIImage imageNamed:@"help2.png"], nil];
    
    self.titleBarOn = YES;
    self.pageControll.frame = CGRectMake(140, 440, 40, 20);
    self.pageControll.numberOfPages = [images count];
    
    self.scrollView.delegate = self;
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(imageViewTouched:)];
    oneTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:oneTap]; 
    
    int x = 0;
    for (UIImage *img in images) {
        CGRect imgFrame = CGRectMake(x, 0, 320, 480);
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = imgFrame;
        
        x += 320;
        [scrollView addSubview:imgView];
    }
    scrollView.contentSize = CGSizeMake(x, 480);
    scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTitleBar:nil];
    [self setPageControll:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVieww {
    if (scrollView != scrollVieww) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    self.page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControll.currentPage = page;
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

@end
