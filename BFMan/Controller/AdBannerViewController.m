//
//  AdBannerViewController.m
//  SmartTao
//
//  Created by Wang Shiyou on 12-1-4.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "AdBannerViewController.h"
#import "JLTAd.h"
#import "JSImageLoader.h"
#import "JSImageLoaderClient.h"

@implementation AdBannerViewController
@synthesize jltAds, server, imgLoaderClients, imgDownloaded, currentAd, displayingImageView, backupImageView, delegate;

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
    self.server = [[JLTServer alloc] initWithDelegate:self];
    
    [server getAd];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changeAd {
    self.currentAd = (++ currentAd) % [jltAds count];
    JLTAd *ad = [jltAds objectAtIndex:currentAd];
    backupImageView.image = ad.image;
    
    backupImageView.frame = CGRectMake(0, 44, 320, 44);
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         displayingImageView.frame = CGRectMake(0, -44, 320, 44);
                         backupImageView.frame = CGRectMake(0, 0, 320, 44);
                     } completion:^(BOOL finished) {
                         displayingImageView.frame = CGRectMake(0, 44, 320, 44);
                         
                         UIImageView *tmp = displayingImageView;
                         self.displayingImageView = backupImageView;
                         self.backupImageView = tmp;
                     }];
    
    [self performSelector:@selector(changeAd) withObject:0 afterDelay:5.0f];
}

- (void)startAnimation {
    [delegate performSelector:@selector(willDisplayAd)];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(adTapped:)];
    recognizer.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:recognizer];
    
    JLTAd *ad = [jltAds objectAtIndex:0];
    self.currentAd = 0;
    self.displayingImageView = [[UIImageView alloc] initWithImage:ad.image];
    self.backupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];

    displayingImageView.frame = CGRectMake(0, -44, 320, 44);
    [self.view addSubview:displayingImageView];
    [self.view addSubview:backupImageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        displayingImageView.frame = CGRectMake(0, 0, 320, 44);
    }];
    
    if ([jltAds count] > 1) {
        [self performSelector:@selector(changeAd) withObject:nil afterDelay:5.0f];        
    }
}

- (void)adTapped:(id)sender {
    JLTAd *ad = [jltAds objectAtIndex:currentAd];
    if ([ad.adUrl isEqualToString:@""]) {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.adUrl]];
}

- (void)jltSucceedWithObject:(id)obj {
    self.jltAds = (NSArray *)obj;
    self.imgLoaderClients = [[NSMutableArray alloc] initWithCapacity:[jltAds count]];
    
    JSImageLoader *loader = [JSImageLoader sharedInstance];
    
    self.imgDownloaded = 0;
    for (JLTAd *ad in jltAds) {
        JSImageLoaderClient *client = [[JSImageLoaderClient alloc] init];
        client.request = [NSURLRequest requestWithURL:[NSURL URLWithString:ad.adPicUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        client.delegate = self;
        [imgLoaderClients addObject:client];
        [loader addClientToDownloadQueue:client];
    }
}

- (void)jltErrorMessage:(NSString *)msg {
    // don't show any error here.
}

- (void)renderImage:(UIImage *)image forClient:(JSImageLoaderClient *)client {
    for (int i = 0; i < [imgLoaderClients count]; ++i) {
        JSImageLoaderClient *c = [imgLoaderClients objectAtIndex:i];
        if ([c isEqual:client]) {
            JLTAd *ad = [jltAds objectAtIndex:i];
            ad.image = image;
            self.imgDownloaded ++;
            break;
        }
    }
    if (imgDownloaded == [jltAds count]) {
        [self startAnimation];
    }
}

- (void)dealloc {
    for (JSImageLoaderClient *client in imgLoaderClients) {
        [client cancelFetch];
    }
}

@end
