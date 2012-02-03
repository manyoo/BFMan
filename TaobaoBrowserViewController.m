//
//  TaobaoBrowserViewController.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-28.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "TaobaoBrowserViewController.h"

@implementation TaobaoBrowserViewController
@synthesize previousButton;
@synthesize nextButton;
@synthesize refreshButton;
@synthesize webView, itemUrl;

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

#pragma mark - UIWebViewControllerDelegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
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

@end
