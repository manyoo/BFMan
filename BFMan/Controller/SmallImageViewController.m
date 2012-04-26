//
//  SmallImageViewController.m
//  BFMan
//
//  Created by  on 12-4-26.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SmallImageViewController.h"
#import "AppDelegate.h"
#import "HuabaoPicture.h"
#import "ItemImg.h"
#import "AsyncImageView.h"

@interface SmallImageViewController (PrivateMethod)
- (void)focusOnPage:(NSInteger)currentPage;
@end

@implementation SmallImageViewController
@synthesize scrollView, pictures, images, subViews, page, delegate;

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
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        ItemImg *img = (ItemImg *)[NSEntityDescription insertNewObjectForEntityForName:@"ItemImg" inManagedObjectContext:context];
        img.url = hp.picUrl;
        [imgitems addObject:img];
    }
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = NO;
    scrollView.delegate = self;
    
    int x = 0;
    
    self.subViews = [[NSMutableArray alloc] initWithCapacity:imgitems.count];
    for (id image in imgitems) {
        CGRect subFrame = CGRectMake(x, 0, 80, scrollView.frame.size.height);
        UIView *subView = [[UIView alloc] initWithFrame:subFrame];
        
        CGRect imgFrame = CGRectMake(0, 0, subFrame.size.width, subFrame.size.height);
        AsyncImageView *imgView = [[AsyncImageView alloc] initWithItemImg:image size:IMG_SMALL andFrame:imgFrame];
        
        //[imgView getImage];
        imgView.tag = 101;
        
        x += 80;
        
        [subView addSubview:imgView];
        [imgView getImage];

        subView.userInteractionEnabled = YES;
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(imageViewTouched:)];
        oneTap.numberOfTapsRequired = 1;
        [subView addGestureRecognizer:oneTap];
        
        [scrollView addSubview:subView];
        [self.subViews addObject:subView];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.bounds.size.height);
    //[self displayPage:page];
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * page, 0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)imageViewTouched:(UITapGestureRecognizer *)v {
    for (int i = 0; i < subViews.count; ++i) {
        UIView *sub = [subViews objectAtIndex:i];
        if (sub == v.view) {
            [delegate pictureSelected:i];
        }
    }
}

@end
