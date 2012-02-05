//
//  ItemBigTableViewCell.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-29.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuaBao;
@class HuabaoCoverView;

@interface ItemBigTableViewCell : UITableViewCell

@property (nonatomic, strong) HuaBao *itemLeft;
@property (nonatomic, strong) HuaBao *itemRight;
@property (nonatomic, strong) HuabaoCoverView *leftView;
@property (nonatomic, strong) HuabaoCoverView *rightView;

- (void)setupCellContentsWithDelegate:(id)delegate;

@end
