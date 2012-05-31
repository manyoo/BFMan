//
//  iPadBrowserViewController.h
//  BFMan
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BailuServer.h"

@interface iPadBrowserViewController : UIViewController <UIWebViewDelegate, BailuServerDelegate>

@property (nonatomic, strong) BailuServer *server;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *itemId;
@property (strong, nonatomic) NSString *itemUrl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)share:(id)sender;

@end
