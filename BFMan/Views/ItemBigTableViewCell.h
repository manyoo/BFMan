//
//  ItemBigTableViewCell.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-29.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuaBao;
@class RedLineView;

@interface ItemBigTableViewCell : UITableViewCell

@property (nonatomic, strong) HuaBao *item;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rebateLabel;
@property (nonatomic, strong) UILabel *realPriceLabel;

- (void)setupCellContents;

@end
