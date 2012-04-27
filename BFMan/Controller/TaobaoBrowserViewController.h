//
//  TaobaoBrowserViewController.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-28.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BailuServer.h"
#import "TBServer.h"

@interface TaobaoBrowserViewController : UIViewController <UIWebViewDelegate, BailuServerDelegate, TBServerDelegate>

@property (nonatomic, strong) TBServer *tbServer;
@property (nonatomic, strong) BailuServer *server;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *itemId;
@property (strong, nonatomic) NSString *itemUrl;

@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)goBack:(id)sender;
- (IBAction)previousPage:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)refreshPage:(id)sender;
- (IBAction)shareThisItem:(id)sender;

@end
