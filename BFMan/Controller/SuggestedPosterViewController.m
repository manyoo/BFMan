//
//  SuggestedPosterViewController.m
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SuggestedPosterViewController.h"
#import "BFManConstants.h"

@implementation SuggestedPosterViewController
@synthesize server;

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
    [super viewDidLoad];
    
    self.title = @"推荐";
    
    self.server = [[TBServer alloc] initWithDelegate:self];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"RECOMMEND" forKey:@"appointed_type"];
    [params setValue:[NSNumber numberWithInt:DEFAULT_CHANNEL] forKey:@"channel_ids"];
    [params setValue:@"20" forKey:@"re_num"];
    [server getAppointedPosters:params];
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
    self.posters = (NSMutableArray *)data;
    self.cellTypes = [[NSMutableArray alloc] initWithCapacity:[self.posters count]];
    for (id o in self.posters) {
        [self.cellTypes addObject:[NSNumber numberWithInt:CELL_DATA]];
    }
    [self.tableView reloadData];
}

@end
