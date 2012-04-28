//
//  ItemCell.h
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaobaokeItem;


@interface ItemCell : UITableViewCell

@property (nonatomic, strong) TaobaokeItem *item;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)setupCellContents;
- (void)setupCellWithTitle:(NSString *)title pic:(NSString *)picUrl price:(NSNumber *)price;

@end
