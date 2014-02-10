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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _recipes = [dict objectForKey:@"RecipeName"];
    _thumbnails = [dict objectForKey:@"Thumbnail"];
    _prepTime = [dict objectForKey:@"PrepTime"];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0f)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"RecipeListViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = _recipes[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_thumbnails[indexPath.row]];
    cell.detailTextLabel.text = _prepTime[indexPath.row];
    
    return cell;
}

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

@end
