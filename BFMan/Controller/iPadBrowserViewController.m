//
//  iPadBrowserViewController.m
//  BFMan
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "iPadBrowserViewController.h"
#import "UMSNSService.h"
#import "BFManConstants.h"
#import "ImageMemCache.h"

@interface iPadBrowserViewController ()

@end

@implementation iPadBrowserViewController
@synthesize webView;
@synthesize backButton;
@synthesize forwardButton;
@synthesize refreshButton;
@synthesize itemUrl, itemId;
@synthesize server, picUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:itemUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    
    backButton.enabled = NO;
    forwardButton.enabled = NO;
    refreshButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setForwardButton:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)goBack:(id)sender {
    [webView goBack];
}

- (IBAction)goForward:(id)sender {
    [webView goForward];
}

- (IBAction)refresh:(id)sender {
    [webView reload];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    if (server == nil) {
        self.server = [[BailuServer alloc] init];
    }
    server.delegate = self;
    [server getShortUrlFor:itemUrl];
}

#pragma mark BailuServerDelegate
- (void)shortUrlFailed:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"暂时不能发送微博，请稍后再试"
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)shortUrlFinished:(NSString *)shortUrl {
    NSString *msg = [NSString stringWithFormat:@"看到一个宝贝，分享给大家！%@ ", shortUrl];
    UIImage *img = [[ImageMemCache sharedImageMemCache] getImageForKey:picUrl];
    [UMSNSService showSNSActionSheetInController:self
                                          appkey:UMENG_APP_KEY_STR
                                          status:msg
                                           image:img];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)wwebView {
    if ([wwebView canGoBack]) {
        backButton.enabled = YES;
    } else {
        backButton.enabled = NO;
    }
    if ([wwebView canGoForward]) {
        forwardButton.enabled = YES;
    } else {
        forwardButton.enabled = NO;
    }
    refreshButton.enabled = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    refreshButton.enabled = NO;
}

@end
