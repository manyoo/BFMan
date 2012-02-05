//
//  ItemBigTableViewCell.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-29.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "ItemBigTableViewCell.h"
#import "GradientView.h"
#import "HuabaoCoverView.h"

@implementation ItemBigTableViewCell
@synthesize itemLeft, itemRight, leftView, rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // background
        GradientView *backgroundView = [[GradientView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        CGFloat c1 = 254.0/255.0, c2 = 240.0/255.0;
        backgroundView.startColor = [UIColor colorWithRed:c1 green:c1 blue:c1 alpha:1.0];
        backgroundView.endColor = [UIColor colorWithRed:c2 green:c2 blue:c2 alpha:1.0];
        [self.contentView addSubview:backgroundView];

        self.leftView = [[HuabaoCoverView alloc] initWithFrame:CGRectMake(0, 0, 160, 180)];
        self.rightView = [[HuabaoCoverView alloc] initWithFrame:CGRectMake(160, 0, 160, 180)];
        [self.contentView addSubview:leftView];
        [self.contentView addSubview:rightView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupCellContentsWithDelegate:(id)delegate {
    leftView.huabao = itemLeft;
    leftView.delegate = delegate;
    [leftView setupView];
    
    rightView.huabao = itemRight;
    rightView.delegate = delegate;
    [rightView setupView];
}

@end
