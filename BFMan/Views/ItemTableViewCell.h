//
//  ItemTableViewCell.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-26.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaobaokeItem;

@interface ItemTableViewCell : UITableViewCell

@property (nonatomic, strong) TaobaokeItem *item;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)setupCellContents;
- (void)setupCellWithTitle:(NSString *)title pic:(NSString *)picUrl price:(NSNumber *)price;

@end
