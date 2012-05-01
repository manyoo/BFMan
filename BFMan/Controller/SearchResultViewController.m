//
//  SearchResultViewController.m
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize keyword;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImageView *navImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBar.png"]];
        navImgView.frame = CGRectMake(0, 0, 320, 44);
        [self.navigationController.navigationBar insertSubview:navImgView atIndex:0];
    }
        
    self.title = keyword;
    
    if ([self.cellTypes count] == 0) {
        self.lastpageLoaded = 1;
        if (self.server == nil) {
            self.server = [[TBServer alloc] initWithDelegate:self];
        }
        NSArray *values = [NSArray arrayWithObjects:keyword, @"20", [NSNumber numberWithInt:self.lastpageLoaded], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"key_word", @"page_size", @"page_no", nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
        self.apiType = API_SEARCH;
        [self.server searchPosters:params];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)loadMoreData {
    self.lastpageLoaded ++;
    NSArray *values = [NSArray arrayWithObjects:keyword, @"20", [NSNumber numberWithInt:self.lastpageLoaded], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"key_word", @"page_size", @"page_no", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    self.apiType = API_SEARCH;
    [self.server searchPosters:params];
}

@end
