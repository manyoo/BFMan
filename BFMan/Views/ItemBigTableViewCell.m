//
//  ItemBigTableViewCell.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-29.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "ItemBigTableViewCell.h"
#import "HuaBao.h"
#import "ItemImg.h"
#import "AsyncImageView.h"
#import "GradientView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ItemBigTableViewCell
@synthesize item, titleLabel, priceLabel, rebateLabel, realPriceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // background
        GradientView *backgroundView = [[GradientView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
        CGFloat c1 = 254.0/255.0, c2 = 240.0/255.0;
        backgroundView.startColor = [UIColor colorWithRed:c1 green:c1 blue:c1 alpha:1.0];
        backgroundView.endColor = [UIColor colorWithRed:c2 green:c2 blue:c2 alpha:1.0];
        [self.contentView addSubview:backgroundView];
        
        // title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 40)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupCellContents {
    if (item == nil)
        return;
    
    UIView *v = [self.contentView viewWithTag:99];
    [v removeFromSuperview];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    ItemImg *img = item.itemImg;
    if (img == nil) {
        img = [NSEntityDescription insertNewObjectForEntityForName:@"ItemImg" inManagedObjectContext:context];
        img.url = item.coverPicUrl;
        item.itemImg = img;
    }
    
    CGRect imgFrame = CGRectMake(30, 10, 260 , 260);
    AsyncImageView *asycImageView = [[AsyncImageView alloc] initWithItemImg:img andFrame:imgFrame];
    asycImageView.tag = 99;
    asycImageView.usedInList = YES;
    
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
    
    [self.contentView addSubview:asycImageView];
    [asycImageView getImage];
    
    item.title = [[item.title stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    
    titleLabel.text = item.title;
}

@end
