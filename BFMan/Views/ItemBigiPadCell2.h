//
//  ItemBigiPadCell2.h
//  BFMan
//
//  Created by  on 12-5-29.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuaBao;
@class HuabaoCoveriPadView;

@interface ItemBigiPadCell2 : UITableViewCell

@property (nonatomic, strong) HuaBao *item1;
@property (nonatomic, strong) HuaBao *item2;
@property (nonatomic, strong) HuaBao *item3;
@property (nonatomic, strong) HuaBao *item4;
@property (nonatomic, strong) HuabaoCoveriPadView *view1;
@property (nonatomic, strong) HuabaoCoveriPadView *view2;
@property (nonatomic, strong) HuabaoCoveriPadView *view3;
@property (nonatomic, strong) HuabaoCoveriPadView *view4;

- (void)setupCellContentsWithDelegate:(id)delegate;

@end
