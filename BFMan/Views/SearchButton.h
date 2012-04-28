//
//  SearchButton.h
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchButton : UIButton

@property (nonatomic) BOOL pressed;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImage *bgPressedImage;

- (void)changeButton;

@end
