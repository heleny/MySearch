//
//  ViewController.m
//  MySearch
//
//  Created by Helen on 2/9/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *_recipes;
    NSArray *_thumbnails;
    NSArray *_prepTime;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _recipes = [dict objectForKey:@"RecipeName"];
    _thumbnails = [dict objectForKey:@"Thumbnail"];
    _prepTime = [dict objectForKey:@"PrepTime"];
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
    static NSString *tableIdentifier = @"ViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = _recipes[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_thumbnails[indexPath.row]];
    cell.detailTextLabel.text = _prepTime[indexPath.row];
    
    return cell;
}

@end
