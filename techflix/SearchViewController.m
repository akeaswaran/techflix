//
//  SecondViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "SearchViewController.h"

#import <HexColors.h>

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


@end
