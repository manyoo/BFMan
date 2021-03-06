//
//  ItemCell.m
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ItemCell.h"
#import "TaobaokeItem.h"
#import "ItemImg.h"
#import "AsyncImageView.h"
#import "GradientView.h"

#define IMAGE_WIDTH 90

@implementation ItemCell
@synthesize item, titleLabel, priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        // title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGE_WIDTH + 10, 0, self.frame.size.width - IMAGE_WIDTH - 20, IMAGE_WIDTH / 2)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        // price label
        
        CGRect priceFrame = CGRectMake(IMAGE_WIDTH + 10, IMAGE_WIDTH / 2 + 10, titleLabel.frame.size.width / 2, 20);
        self.priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.textColor = [UIColor darkGrayColor];
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