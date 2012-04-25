//
//  HotPosterViewController.m
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HotPosterViewController.h"
#import "BFManConstants.h"
#import "HelpPhotoViewController.h"

@implementation HotPosterViewController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)doRequest {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"HOT" forKey:@"appointed_type"];
    [params setValue:self.currentChannelId forKey:@"channel_ids"];
    [params setValue:@"20" forKey:@"re_num"];
    self.apiType = API_GETHOT;
    [self.server getAppointedPosters:params];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.refreshEnabled = NO;
    self.multipageEnabled = NO;
    [super viewDidLoad];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImageView *navImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBar.png"]];
        navImgView.frame = CGRectMake(0, 0, 320, 44);
        [self.navigationController.navigationBar insertSubview:navImgView atIndex:0];
    }
    
    self.title = @"热门";
    
    self.server = [[TBServer alloc] initWithDelegate:self];
    [self doRequest];
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];    
        
        NSURL *fileUrl = [NSURL URLWithString:@"first_startup" relativeToURL:documentDir];
        
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
        if (!hasFile) {
            NSString *text = @"started";
            [text writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
            HelpPhotoViewController *photo = [[HelpPhotoViewController alloc] initWithNibName:@"HelpPhotoViewController" bundle:nil];
            [self presentModalViewController:photo animated:YES];       
        }
    }
}

- (void)reloadTableViewDataSource {
    [super reloadTableViewDataSource];
    [self doRequest];
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

- (void)requestFailed:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_NOTIFY
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)requestFinished:(id)data {
    if (self.apiType == API_GETHOT) {
        self.posters = (NSMutableArray *)data;
        self.cellTypes = [[NSMutableArray alloc] initWithCapacity:[self.posters count]];
        for (id o in self.posters) {
            [self.cellTypes addObject:[NSNumber numberWithInt:CELL_DATA]];
        }
        if (self.reloading) {
            [self doneLoadingTableViewData];
        }
        [self.tableView reloadData];   
    } else
        [super requestFinished:data];
}

- (void)loadNewChannel {
    [self doRequest];
}

@end
