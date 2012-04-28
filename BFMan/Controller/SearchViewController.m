//
//  SearchViewController.m
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryManager.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchBar = _searchBar, searchListButtonView, keyword, searchTypeHasChanged, listType, searchHistory, hottestSearches;

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
    self.title = @"搜索画报";
    UILabel *label = [[UILabel alloc] init];
    self.navigationItem.titleView = label;
    label.text = @"";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:192.0/255 green:66.0/255 blue:43.0/255 alpha:1.0];
    
    self.searchTypeHasChanged = NO;
    
    self.listType = SL_HISTORY;
    self.searchHistory = [[SearchHistoryManager defaultManager] getSearchHistoryList];

    self.navigationController.delegate = self;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.tintColor = [UIColor colorWithRed:192.0/255 green:66.0/255 blue:43.0/255 alpha:1.0];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索画报";
    [self.navigationController.navigationBar addSubview:_searchBar];
    [_searchBar setShowsCancelButton:YES];
    
    for (UIView *v in _searchBar.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)v;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    self.searchListButtonView = [[SearchListButtonView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    searchListButtonView.delegate = self;
    self.tableView.tableHeaderView = searchListButtonView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.searchBar removeFromSuperview];
    self.searchBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (listType == SL_HISTORY) {
        return [searchHistory count] + 1;
    } else {
        return [hottestSearches count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    if (listType == SL_HISTORY) {
        if (indexPath.row == searchHistory.count) {
            cell.textLabel.text = @"清除搜索历史";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        } else
            cell.textLabel.text = [searchHistory objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [hottestSearches objectAtIndex:indexPath.row];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         NSIndexSet *idx = [[NSIndexSet alloc] initWithIndex:indexPath.row];
         [searchHistory removeObjectAtIndex:indexPath.row];
         [[SearchHistoryManager defaultManager] deleteHistoryAtIndex:idx];
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (listType == SL_HISTORY) {
        if (indexPath.row == searchHistory.count) {
            return NO;
        } else
            return YES;
    } else {
        return NO;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    SearchResultViewController *resultController = [[SearchResultViewController alloc] initWithNibName:@"PosterViewController" bundle:nil];
    
    if (listType == SL_HISTORY) {
        if (indexPath.row == searchHistory.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:searchHistory.count];
            for (int i = 0; i < indexPath.row; ++i) {
                NSIndexPath *idp = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:idp];
            }
            NSIndexSet *idx = [searchHistory indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return YES;
            }];
            [searchHistory removeObjectsAtIndexes:idx];
            [[SearchHistoryManager defaultManager] deleteHistoryAtIndex:idx];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        } else {
            NSString *hist = [searchHistory objectAtIndex:indexPath.row];
            resultController.keyword = hist;
            [UIView animateWithDuration:0.3 animations:^{
                self.searchBar.alpha = 0.0;
                self.searchBar.frame = CGRectMake(-320, 0, 320, 44);
            }];
            [self.navigationController pushViewController:resultController animated:YES];   
        }
    } else {
        NSString *kw = [hottestSearches objectAtIndex:indexPath.row];
        resultController.keyword = kw;
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.alpha = 0.0;
            self.searchBar.frame = CGRectMake(-320, 0, 320, 44);
        }];
        [self.navigationController pushViewController:resultController animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBar.alpha = 1.0;
            self.searchBar.frame = CGRectMake(0, 0, 320, 44);
        }];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, MAXFLOAT)];
    v.backgroundColor = [UIColor darkGrayColor];
    v.tag = 2011;
    v.alpha = 0;
    [self.tableView addSubview:v];
    
    [UIView animateWithDuration:0.3 animations:^{
        v.alpha = 0.8;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    UIView *v = [self.tableView viewWithTag:2011];
    
    [UIView animateWithDuration:0.3 animations:^{
        v.alpha = 0.0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    if (keyword == nil) {
        return;
    }
    [searchBar resignFirstResponder];
    
    [[SearchHistoryManager defaultManager] addSearchHistory:keyword];

    SearchResultViewController *resultViewController = [[SearchResultViewController alloc] initWithNibName:@"PosterViewController"bundle:nil];
    resultViewController.keyword = keyword;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.alpha = 0.0;
        self.searchBar.frame = CGRectMake(-320, 0, 320, 44);
    }];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText == nil || [searchText isEqualToString:@""]) {
        self.keyword = nil;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchTypeHasChanged = NO;
}

- (void)listTypeSelected:(SearchListType)type {
    self.listType = type;
    [self.tableView reloadData];
}

@end
