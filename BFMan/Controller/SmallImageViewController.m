//
//  SmallImageViewController.m
//  BFMan
//
//  Created by  on 12-4-26.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SmallImageViewController.h"
#import "HuabaoPicture.h"
#import "ItemImg.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageMemCache.h"

@interface SmallImageViewController (PrivateMethod)
- (void)focusOnPage:(NSInteger)currentPage;
@end

@implementation SmallImageViewController
@synthesize scrollView, pictures, images, imgViews, page, delegate, currentImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *imgitems = [[NSMutableArray alloc] initWithCapacity:pictures.count];
    for (HuabaoPicture *hp in pictures) {
        ItemImg *img = [[ItemImg alloc] init];
        img.url = hp.picUrl;
        [imgitems addObject:img];
    }
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    int x = 0;
    
    self.imgViews = [[NSMutableArray alloc] initWithCapacity:imgitems.count];
    for (id image in imgitems) {
        CGRect imgFrame = CGRectMake(x, 10, 80, scrollView.frame.size.height);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image size:IMG_SMALL andFrame:imgFrame];
        imgView.usedInPageControl = YES;
        //[imgView getImage];
        
        x += 85;
        
        [scrollView addSubview:imgView];
        [imgView getImage];
        [imgView enableTouch];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewTouched:)];
        oneTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:oneTap];
        
        [self.imgViews addObject:imgView];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    //[self displayPage:page];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.imgViews = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[ImageMemCache sharedImageMemCache] clearCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)imageViewTouched:(UITapGestureRecognizer *)v {
    for (int i = 0; i < imgViews.count; ++i) {
        AsyncImageView *imgView = (AsyncImageView *)[imgViews objectAtIndex:i];
        if (imgView == v.view) {
            [currentImageView setSelected:NO];
            self.currentImageView = imgView;
            [imgView setSelected:YES];
            [delegate pictureSelected:i];
        }
    }
}

- (void)setSelectedPicture:(int)pagee {
    self.page = pagee;
    [currentImageView setSelected:NO];
    AsyncImageView *imgView = (AsyncImageView *)[imgViews objectAtIndex:pagee];
    self.currentImageView = imgView;
    [imgView setSelected:YES];
    
    [scrollView scrollRectToVisible:CGRectMake(pagee * 85 - 80, 0, 240, scrollView.frame.size.height) animated:YES]; 
}

@end
