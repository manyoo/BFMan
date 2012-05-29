//
//  ItemBigiPadCell2.m
//  BFMan
//
//  Created by  on 12-5-29.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ItemBigiPadCell2.h"
#import "HuaBao.h"
#import "HuabaoCoveriPadView.h"

@implementation ItemBigiPadCell2

@synthesize item1, item2, item3, item4, view1, view2, view3, view4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.view1 = [[HuabaoCoveriPadView alloc] initWithFrame:CGRectMake(28, 0, 200, 250)];
        self.view2 = [[HuabaoCoveriPadView alloc] initWithFrame:CGRectMake(284, 0, 200, 250)];
        self.view3 = [[HuabaoCoveriPadView alloc] initWithFrame:CGRectMake(540, 0, 200, 250)];
        self.view4 = [[HuabaoCoveriPadView alloc] initWithFrame:CGRectMake(796, 0, 200, 250)];
        [self.contentView addSubview:view1];
        [self.contentView addSubview:view2];
        [self.contentView addSubview:view3];
        [self.contentView addSubview:view4];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupCellContentsWithDelegate:(id)delegate {
    view1.huabao = item1;
    view1.delegate = delegate;
    [view1 setupView];
    
    if (item2) {
        view2.huabao = item2;
        view2.delegate = delegate;
        [view2 setupView];
        view2.alpha = 1.0;
    } else {
        view2.alpha = 0.0;
    }
    
    if (item3) {
        view3.huabao = item3;
        view3.delegate = delegate;
        [view3 setupView];
        view3.alpha = 1.0;
    } else {
        view3.alpha = 0.0;
    }
    
    if (item4) {
        view4.huabao = item4;
        view4.delegate = delegate;
        [view4 setupView];
        view4.alpha = 1.0;
    } else {
        view4.alpha = 0.0;
    }
}



@end
