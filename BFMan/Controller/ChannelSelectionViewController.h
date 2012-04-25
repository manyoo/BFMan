//
//  ChannelSelectionViewController.h
//  BFMan
//
//  Created by  on 12-4-25.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelSelectionViewControllerDelegate <NSObject>

- (void)channelSelected:(NSNumber *)channelId;

@end

@interface ChannelSelectionViewController : UIViewController

@property (nonatomic, strong) NSArray *channelNames;
@property (nonatomic, strong) NSMutableArray *channelIds;

@property (nonatomic, unsafe_unretained) id<ChannelSelectionViewControllerDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *currentButton;

@end
