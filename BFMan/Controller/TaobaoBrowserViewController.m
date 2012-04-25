//
//  TaobaoBrowserViewController.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-28.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "TaobaoBrowserViewController.h"
#import "WBSendView.h"
#import "WeiboManager.h"
#import "BlogClient.h"
#import "BFManConstants.h"

@implementation TaobaoBrowserViewController
@synthesize previousButton;
@synthesize nextButton;
@synthesize refreshButton;
@synthesize webView, itemUrl, itemId;
@synthesize server, picUrl;
@synthesize sendView;
@synthesize tbServer;
@synthesize imageLoaderClient, picForWeibo;

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
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"分享"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"分享到新浪微博", nil];
    [action showInView:self.view];
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        BlogClient *client = [WeiboManager getBlogClient];
        if ([client isAuthorized]) {
            if (tbServer == nil) {
                self.tbServer = [[TBServer alloc] init];
                tbServer.delegate = self;
            }
            [tbServer convertTaobaokeItems:itemId];
            if (imageLoaderClient == nil) {
                self.imageLoaderClient = [[JSImageLoaderClient alloc] init];
            }
            imageLoaderClient.request = [NSURLRequest requestWithURL:[NSURL URLWithString:picUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            imageLoaderClient.delegate = self;
            JSImageLoader *imageLoader = [JSImageLoader sharedInstance];
            [imageLoader addClientToDownloadQueue:imageLoaderClient];
        } else {
            UIViewController *oauthViewController = [client getOAuthViewController:self];
            [self presentModalViewController:oauthViewController animated:YES];
        }
    }
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
    self.sendView = [[WBSendView alloc] initWithWeiboText:[NSString stringWithFormat:@"非常喜欢这个宝贝哦，推荐大家看看！%@", shortUrl]
                                                withImage:picForWeibo
                                                      url:picUrl
                                            aditionalText:nil
                                              andDelegate:self];
    [sendView show];
}


- (void)OAuthViewControllerOk:(NSString *)text {
    BlogClient *blog = [WeiboManager getBlogClient];
    NSString *uid = [blog.oauth userID];
    
    [blog show:@"" user_id:uid screen_name:@"" delegate:self onSuccess:@selector(getWeiboUser:dict:) onFail:@selector(weiboFailed:msg:)];
}

- (void)OAuthViewControllerCancel:(NSString *)text {
    
}

- (void)getWeiboUser:(NSNumber *)code dict:(NSDictionary *)userDict {
    BlogClient *blog = [WeiboManager getBlogClient];
    blog.user = [[WeiboUser alloc] initWithDictionary:userDict];
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];
        
        NSURL *fileUrl = [NSURL URLWithString:WEIBO_USER_FILE relativeToURL:documentDir];
        
        NSString *t = [NSString stringWithFormat:@"%@\n%@",blog.user.userId,blog.user.screen_name];
        [t writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)weiboFailed:(NSNumber *)code msg:(NSString *)str {
    
}

- (void)postSucceeded {
    [sendView dismiss:YES];
}

- (void)postFailed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"微博没有发送成功哦，过一会再试试吧。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark TBServerDelegate
- (void)requestFailed:(NSString *)msg {
    
}

- (void)requestFinished:(id)data {
    NSString *url;
    if (data == nil) {
        url = itemUrl;
    } else
        url = (NSString *)data;
    if (server == nil) {
        self.server = [[BailuServer alloc] init];
    }
    server.delegate = self;
    [server getShortUrlFor:url];
}


#pragma mark CacheImageLoaderDelegate
- (void)renderImage:(UIImage *)image forClient:(JSImageLoaderClient *)client {
    self.picForWeibo = image;
}

- (void)dealloc {
    [imageLoaderClient cancelFetch];
    imageLoaderClient.delegate = nil;
}

@end
