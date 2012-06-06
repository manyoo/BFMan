//
//  ChannelSelectioniPadViewController.h
//  BFMan
//
//  Created by  on 12-5-29.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelSelectioniPadViewControllerDelegate <NSObject>

- (void)channelSelected:(NSNumber *)channelId name:(NSString *)name;

@end

@interface ChannelSelectioniPadViewController : UITableViewController

@property (nonatomic, strong) NSArray *channelNames;
@property (nonatomic, strong) NSMutableArray *channelIds;

@property (nonatomic, unsafe_unretained) id<ChannelSelectioniPadViewControllerDelegate> delegate;

@end
