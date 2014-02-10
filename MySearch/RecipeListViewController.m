//
//  ViewController.m
//  MySearch
//
//  Created by Helen on 2/9/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "RecipeListViewController.h"
#import "ODRefreshControl.h"

@interface RecipeListViewController ()

@end

@implementation RecipeListViewController {
    NSArray *_recipes;
    NSArray *_thumbnails;
    NSArray *_prepTime;

    UISearchDisplayController *_searchDisplayController;
//    UIRefreshControl *_refreshControl;
    ODRefreshControl *_refreshControl;

    NSArray *_searchResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _recipes = [dict objectForKey:@"RecipeName"];
    _thumbnails = [dict objectForKey:@"Thumbnail"];
    _prepTime = [dict objectForKey:@"PrepTime"];

    _searchResult = _recipes;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0f)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    self.tableView.tableHeaderView = searchBar;

    // Add UIRefreshController
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
//    _refreshControl = [UIRefreshControl new];
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResult count];
    } else {
        return [_recipes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"RecipeListViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = _searchResult[indexPath.row];
    } else {
        cell.textLabel.text = _recipes[indexPath.row];
    }

    cell.imageView.image = [UIImage imageNamed:_thumbnails[indexPath.row]];
    cell.detailTextLabel.text = _prepTime[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[controller.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

#pragma mark - Selector

//- (void)pullToRefresh:(id)sender
//{
//    [_refreshControl endRefreshing];
//}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

#pragma mark - helper

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];

    _searchResult = [_recipes filteredArrayUsingPredicate:resultPredicate];
}

@end
