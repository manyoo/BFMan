//
//  AllPosterViewController.m
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "AllPosterViewController.h"
#import "BFManConstants.h"

@implementation AllPosterViewController

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.multipageEnabled = YES;
    self.searchEnabled = YES;
    [super viewDidLoad];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImageView *navImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBar.png"]];
        navImgView.frame = CGRectMake(0, 0, 320, 44);
        [self.navigationController.navigationBar insertSubview:navImgView atIndex:0];
    }
    self.title = @"全部";
    
    self.server = [[TBServer alloc] initWithDelegate:self];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.currentChannelId forKey:@"channel_id"];
    [params setValue:@"20" forKey:@"page_size"];
    [params setValue:@"1" forKey:@"page_no"];
    self.allItemsReloading = YES;
    self.apiType = API_GETALL;
    [self.server getPosters:params];
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
    if (self.apiType == API_GETALL) {
        NSMutableArray *newItems = (NSMutableArray *)data;
        if (self.allItemsReloading) {
            self.posters = newItems;
            self.cellTypes = [[NSMutableArray alloc] initWithCapacity:[self.posters count] + 1];
            self.allItemsReloading = NO;
        } else {
            if ([self.posters count] < [self.cellTypes count]) {
                // there's a loading cell at the end of the table.
                [self.cellTypes removeObjectAtIndex:([self.cellTypes count] - 1)];
            }
            [self.posters addObjectsFromArray:newItems];
        }
        for (id o in newItems) {
            [self.cellTypes addObject:[NSNumber numberWithInt:CELL_DATA]];
        }
        if (newItems.count == 20) {
            [self.cellTypes addObject:[NSNumber numberWithInt:CELL_RELOAD]];
        }
        
        self.lastpageLoaded ++;

        [self.tableView reloadData];
    } else 
        [super requestFinished:data];
}

- (void)loadMoreData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.currentChannelId forKey:@"channel_id"];
    [params setValue:@"20" forKey:@"page_size"];
    [params setValue:[NSNumber numberWithInt:(self.lastpageLoaded + 1)] forKey:@"page_no"];
    self.apiType = API_GETALL;
    [self.server getPosters:params];
}

- (void)loadNewChannel {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.currentChannelId forKey:@"channel_id"];
    [params setValue:@"20" forKey:@"page_size"];
    [params setValue:@"1" forKey:@"page_no"];
    self.allItemsReloading = YES;
    self.apiType = API_GETALL;
    [self.server getPosters:params];
}

@end
