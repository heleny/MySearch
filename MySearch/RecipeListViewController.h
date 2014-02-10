//
//  ViewController.h
//  MySearch
//
//  Created by Helen on 2/9/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

@import UIKit;

@interface RecipeListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
