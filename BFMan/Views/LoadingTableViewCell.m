//
//  LoadingTableViewCell.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-26.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "LoadingTableViewCell.h"

@implementation LoadingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(110, 20, 30, 30);
        [activity startAnimating];
        [self.contentView addSubview:activity];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 100, 30)];
        loadingLabel.textColor = [UIColor lightGrayColor];
        loadingLabel.text = @"正在加载";
        [self.contentView addSubview:loadingLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
