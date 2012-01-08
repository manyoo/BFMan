//
//  ItemBigTableViewCell.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-29.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "ItemBigTableViewCell.h"
#import "TaobaokeItem.h"
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
        
        // price label
        CGRect priceFrame = CGRectMake(10, 275, titleLabel.frame.size.width / 2, 20);
        self.priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.textColor = [UIColor darkGrayColor];
        priceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:priceLabel];
        
        self.realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        realPriceLabel.font = [UIFont systemFontOfSize:12];
        realPriceLabel.textColor = [UIColor darkGrayColor];
        realPriceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:realPriceLabel];
        realPriceLabel.hidden = YES;
        
        // rebate label
        CGRect rebateFrame = CGRectMake(10 + priceFrame.size.width, 275, priceFrame.size.width, priceFrame.size.height);
        self.rebateLabel = [[UILabel alloc] initWithFrame:rebateFrame];
        rebateLabel.backgroundColor = [UIColor clearColor];
        rebateLabel.textAlignment = UITextAlignmentRight;
        rebateLabel.textColor = [UIColor darkGrayColor];
        rebateLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:rebateLabel];
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
    
    ItemImg *img = item.itemImage;
    if (img == nil) {
        img = [NSEntityDescription insertNewObjectForEntityForName:@"ItemImg" inManagedObjectContext:context];
        img.url = item.picUrl;
        item.itemImage = img;
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
    
    NSString *price = [NSString stringWithFormat:@"价格: %@元", item.price];
    CGSize s = [price sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    CGRect f = priceLabel.frame;
    priceLabel.frame = CGRectMake(10, 275, s.width, 20);
    priceLabel.text = price;
    if ([item.realPrice floatValue] > 0) {
        
        NSString *newPrice = [NSString stringWithFormat:@"促销: %@元", item.realPrice];
        CGSize ns = [newPrice sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        realPriceLabel.frame = CGRectMake(f.origin.x + s.width + 10, 275, ns.width, 20);
        realPriceLabel.text = newPrice;
        realPriceLabel.textAlignment = UITextAlignmentRight;
        realPriceLabel.textColor = [UIColor redColor];
        realPriceLabel.hidden = NO;
        
    } else {
        for (UIView *v in priceLabel.subviews) {
            [v removeFromSuperview];
        }
        priceLabel.frame = CGRectMake(10, 275, 100, 20);
        realPriceLabel.hidden = YES;
    }
    
    
}

@end
