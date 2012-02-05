//
//  HuabaoCoverView.h
//  BFMan
//
//  Created by  on 12-2-5.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuaBao;
@interface HuabaoCoverView : UIView

@property (nonatomic, strong) HuaBao *huabao;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *clicksLabel;
@property (nonatomic, strong) UIImageView *tagView;

- (void)setupView;

@end
