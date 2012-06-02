//
//  ItemTableViewCell.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-26.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "TaobaokeItem.h"
#import "ItemImg.h"
#import "AsyncImageView.h"
#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_WIDTH 90

@implementation ItemTableViewCell
@synthesize item, titleLabel, priceLabel, usedIniPad;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inIpad:(BOOL)inIpad frame:(CGRect)f
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.usedIniPad = inIpad;
        if (!usedIniPad) {
            self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
            self.backgroundView.backgroundColor = [UIColor blackColor];
            self.backgroundView.alpha = 0.7;
        }
        
        self.frame = f;
        
        // title label
        CGRect f;
        if (usedIniPad) {
            f = CGRectMake(0, IMAGE_WIDTH, self.frame.size.width, self.frame.size.height - IMAGE_WIDTH - 35);
        } else {
            f = CGRectMake(IMAGE_WIDTH + 10, 0, self.frame.size.width - IMAGE_WIDTH - 20, IMAGE_WIDTH / 2);
        }
        self.titleLabel = [[UILabel alloc] initWithFrame:f];
        titleLabel.font = [UIFont systemFontOfSize:17];
        if (usedIniPad) {
            titleLabel.textColor = [UIColor darkTextColor];
        } else {
            titleLabel.textColor = [UIColor whiteColor];            
        }
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        // price label
        
        CGRect pf;
        if (usedIniPad) {
            pf = CGRectMake(IMAGE_WIDTH + 10, 10, self.frame.size.width - IMAGE_WIDTH - 20, 20);
        } else {
            pf = CGRectMake(IMAGE_WIDTH + 10, IMAGE_WIDTH / 2 + 10, titleLabel.frame.size.width / 2, 20);
        }
        self.priceLabel = [[UILabel alloc] initWithFrame:pf];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = UITextAlignmentLeft;
        if (usedIniPad) {
            priceLabel.textColor = [UIColor darkTextColor];
        } else {
            priceLabel.textColor = [UIColor whiteColor];
        }
        priceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:priceLabel];
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

    ItemImg *img = item.itemImage;
    if (img == nil) {
        img = [[ItemImg alloc] init];
        img.url = item.picUrl;
        item.itemImage = img;
    }
    
    CGRect imgFrame = CGRectMake(2, 2, IMAGE_WIDTH - 4, 76);
    AsyncImageView *asycImageView = [[AsyncImageView alloc] initWithItemImg:img size:IMG_MIDDEL andFrame:imgFrame];
    asycImageView.tag = 99;
    asycImageView.usedInList = YES;
    [self.contentView addSubview:asycImageView];
    [asycImageView getImage];
    
    if (usedIniPad) {
        
        [[asycImageView layer] setShadowOffset:CGSizeMake(2, 1)];
        [[asycImageView layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
        [[asycImageView layer] setShadowRadius:2.5];
        [[asycImageView layer] setShadowOpacity:0.9];
        
        asycImageView.layer.borderWidth = 1.0;
        asycImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        CGSize size = asycImageView.bounds.size;
        CGFloat curlFactor = 8.0f;
        CGFloat shadowDepth = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(size.width, 0.0f)];
        [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
        [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
                controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
                controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
        [asycImageView.layer setShadowPath:path.CGPath];
        
    }
    
    item.title = [[item.title stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];

    titleLabel.text = item.title;
    
    NSString *price = [NSString stringWithFormat:@"价格: %@元", item.price];
    priceLabel.text = price;
}

- (void)setupCellWithTitle:(NSString *)title pic:(NSString *)picUrl price:(NSNumber *)price {
    UIView *v = [self.contentView viewWithTag:99];
    [v removeFromSuperview];
    
    ItemImg *img = [[ItemImg alloc] init];
    img.url = picUrl;
    item.itemImage = img;
    
    
    CGRect imgFrame = CGRectMake(2, 2, IMAGE_WIDTH - 4, 76);
    AsyncImageView *asycImageView = [[AsyncImageView alloc] initWithItemImg:img size:IMG_MIDDEL andFrame:imgFrame];
    asycImageView.tag = 99;
    asycImageView.usedInList = YES;
    [self.contentView addSubview:asycImageView];
    [asycImageView getImage];
    
    titleLabel.text = [[title stringByReplacingOccurrencesOfString:@"<span class=H>" withString:@""] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    
    priceLabel.text = [NSString stringWithFormat:@"价格: %@元", price];
}

@end
