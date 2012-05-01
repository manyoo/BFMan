//
//  ChannelSelectionViewController.m
//  BFMan
//
//  Created by  on 12-4-25.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ChannelSelectionViewController.h"
#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

@interface ChannelSelectionViewController ()

@end

@implementation ChannelSelectionViewController
@synthesize channelIds, channelNames, delegate, currentButton, scrollView, buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.channelNames = [NSArray arrayWithObjects:@"服饰", @"男人", @"女人",@"时尚",@"美容",@"运动",@"亲子",@"创意",@"数码", @"汽车", @"旅游", @"结婚", @"家居", @"娱乐", @"明星",@"宠物", @"旺铺",@"商城家装", @"实惠", nil];
        int channel_ids[19] = {2,3,9,7,8,4,6,13,1,14,18,21,5,15,16,17,22,23,20};
        self.channelIds = [[NSMutableArray alloc] initWithCapacity:19];
        for (int i = 0; i < 19; ++i) {
            [channelIds addObject:[NSNumber numberWithInt:channel_ids[i]]];
        }
    }
    return self;
}

- (void)setNormal:(UIButton *)button {
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
}

- (void)setHighlight:(UIButton *)button {
    [button setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    GradientView *backgroundView = [[GradientView alloc] initWithFrame:CGRectMake(0, 0, 320, 39.5)];
    CGFloat c1 = 254.0/255.0, c2 = 240.0/255.0;
    backgroundView.startColor = [UIColor colorWithRed:c1 green:c1 blue:c1 alpha:1.0];
    backgroundView.endColor = [UIColor colorWithRed:c2 green:c2 blue:c2 alpha:1.0];
    [self.view addSubview:backgroundView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    scrollView.bounces = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.scrollEnabled = YES;
    
    self.buttons = [[NSMutableArray alloc] initWithCapacity:channelNames.count];
    float x = 10;
    float height = self.view.bounds.size.height;
    for (NSString *type in channelNames) {
        CGSize size = [type sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, height)];
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, size.width + 10, height)];
        UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (height - size.height) / 2, size.width + 10, size.height)];
        [typeButton setTitle:type forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self setNormal:typeButton];
        
        typeButton.layer.cornerRadius = 5;
        typeButton.clipsToBounds = YES;
        
        [buttonView addSubview:typeButton];
        [scrollView addSubview:buttonView];
        [buttons addObject:typeButton];
        x += size.width + 10;
    }
    scrollView.contentSize = CGSizeMake(x, height);
    UIButton *defButton = [buttons objectAtIndex:0];
    self.currentButton = defButton;
    [self setHighlight:currentButton];
    
    [self.view addSubview:scrollView];
    
    self.view.layer.shadowRadius = 2.0;
    self.view.layer.shadowOpacity = 0.7;
    self.view.layer.shadowOffset = CGSizeMake(0, 1);
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.buttons = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buttonTapped:(UIButton *)bt {
    if (bt == currentButton) {
        return;
    }
    [self setNormal:currentButton];
    
    for (UIButton *b in buttons) {
        if (b == bt) {
            self.currentButton = b;
            [self setHighlight:currentButton];
            
            int idx = [buttons indexOfObject:b];
            NSNumber *channelId = [channelIds objectAtIndex:idx];
            [delegate channelSelected:channelId];
            break;
        }
    }
}

@end
