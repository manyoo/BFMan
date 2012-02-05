//
//  HuabaoCoverView.m
//  BFMan
//
//  Created by  on 12-2-5.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HuabaoCoverView.h"
#import "HuaBao.h"
#import "ItemImg.h"
#import "AsyncImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation HuabaoCoverView
@synthesize huabao, delegate, titleLabel, clicksLabel, tagView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 148, 145, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        UIImage *lblImg = [[UIImage imageNamed:@"tagLabel.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:15];
        self.tagView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
        tagView.image = lblImg;
        tagView.alpha = 0.8;
        [self addSubview:tagView];
        
        self.clicksLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 12, 95, 15)];
        clicksLabel.font = [UIFont systemFontOfSize:11];
        clicksLabel.textColor = [UIColor whiteColor];
        clicksLabel.backgroundColor = [UIColor clearColor];
        clicksLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:clicksLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupView {
    if (huabao == nil)
        return;
    
    UIView *v = [self viewWithTag:99];
    [v removeFromSuperview];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    ItemImg *img = huabao.itemImg;
    if (img == nil) {
        img = [NSEntityDescription insertNewObjectForEntityForName:@"ItemImg" inManagedObjectContext:context];
        img.url = huabao.coverPicUrl;
        huabao.itemImg = img;
    }
    
    CGRect imgFrame = CGRectMake(10, 5, 140, 140);
    AsyncImageView *asycImageView = [[AsyncImageView alloc] initWithItemImg:img andFrame:imgFrame];
    asycImageView.tag = 99;
    asycImageView.usedInList = YES;
    
    [asycImageView enableTouch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.numberOfTapsRequired = 1;
    [asycImageView addGestureRecognizer:tap];
    
    [[asycImageView layer] setShadowOffset:CGSizeMake(2, 1)];
    [[asycImageView layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [[asycImageView layer] setShadowRadius:2.5];
    [[asycImageView layer] setShadowOpacity:0.9];
    
    CGSize size = asycImageView.bounds.size;
    CGFloat curlFactor = 10.0f;
    CGFloat shadowDepth = 5.0f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    [asycImageView.layer setShadowPath:path.CGPath];
    
    [self insertSubview:asycImageView atIndex:0];
    [asycImageView getImage];
    
    huabao.title = [[huabao.title stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    
    titleLabel.text = huabao.title;
    
    clicksLabel.text = [NSString stringWithFormat:@"人气: %@", huabao.hits];
    
    CGSize ns = [clicksLabel.text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    CGRect oldFrame = tagView.frame;
    tagView.frame = CGRectMake(150 - ns.width - 5, oldFrame.origin.y, ns.width + 10, oldFrame.size.height);
}

- (void)imageTapped:(id)sender {
    [delegate performSelector:@selector(openHuabao:) withObject:huabao];
}

@end
