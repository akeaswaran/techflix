//
//  FirstViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TopMoviesViewController.h"

#import <HexColors.h>

@interface TopMoviesViewController ()
{
    NSArray *movies;
}
@end

@implementation TopMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    self.title = @"Top Movies";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
}

-(void)refreshData {
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return movies.count;
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MovieCell"];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //left intentionally empty for row actions to work
}

-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Save" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[favAction];
}

@end
