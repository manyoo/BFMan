//
//  TaobaoBrowserViewController.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-28.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "TaobaoBrowserViewController.h"
#import "BFManConstants.h"
#import "UMSNSService.h"
#import "JSImageLoader.h"
#import "JSImageLoaderCache.h"

@implementation TaobaoBrowserViewController
@synthesize previousButton;
@synthesize nextButton;
@synthesize refreshButton;
@synthesize webView, itemUrl, itemId;
@synthesize server, picUrl;
@synthesize tbServer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"淘宝网";

    NSURL *url = [[NSURL alloc] initWithString:itemUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    self.previousButton.enabled = NO;
    self.nextButton.enabled = NO;
    self.refreshButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBack:(id)sender {
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    } else
        [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)previousPage:(id)sender {
    [self.webView goBack];
}

- (IBAction)nextPage:(id)sender {
    [self.webView goForward];
}

- (IBAction)refreshPage:(id)sender {
    [self.webView reload];
}

- (IBAction)shareThisItem:(id)sender {
    if (tbServer == nil) {
        self.tbServer = [[TBServer alloc] initWithDelegate:self];
    }
    [tbServer convertTaobaokeItems:itemId];
}

#pragma mark - UIWebViewControllerDelegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    [aWebView stringByEvaluatingJavaScriptFromString:@"var btn=document.getElementsByClassName(\"cart btn\")[0];btn.style.display=\"none\";"];
    [aWebView stringByEvaluatingJavaScriptFromString:@"var btn2 = document.getElementsByClassName(\"btn-blue\")[0];btn2.style.display=\"none\";"];
    
    if ([aWebView canGoBack])
        self.previousButton.enabled = YES;
    else
        self.previousButton.enabled = NO;
    
    if ([aWebView canGoForward])
        self.nextButton.enabled = YES;
    else
        self.nextButton.enabled = NO;
    
    self.refreshButton.enabled = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.previousButton.enabled = NO;
    self.nextButton.enabled = NO;
    self.refreshButton.enabled = NO;
}

- (void)requestFailed:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"暂时不能发送微博，请稍后再试"
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)requestFinished:(id)data {
    NSString *url = (NSString *)data;
    if (url == nil) {
        url = itemUrl;
    }
    if (server == nil) {
        self.server = [[BailuServer alloc] init];
    }
    server.delegate = self;
    [server getShortUrlFor:url];
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
    JSImageLoaderCache *cache = [JSImageLoaderCache sharedCache];
    UIImage *img = [UIImage imageWithData:[cache imageDataInCacheForURLString:picUrl]];
    [UMSNSService showSNSActionSheetInController:self
                                          appkey:UMENG_APP_KEY_STR
                                          status:msg
                                           image:img];
}

@end
