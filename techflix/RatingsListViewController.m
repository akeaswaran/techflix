//
//  RatingsListViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RatingsListViewController.h"
#import "Rating.h"
#import "Movie.h"
#import "User.h"

#import "HexColors.h"

@interface RatingsListViewController ()
{
    NSArray *ratings;
    Movie *selectedMovie;
}
@end

@implementation RatingsListViewController

-(instancetype)initWithMovie:(Movie *)mov {
    if (self = [super init]) {
        selectedMovie = mov;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setRowHeight:100];
    [self.tableView setEstimatedRowHeight:100];
    
    ratings = [selectedMovie allRatings];
    self.title = @"Ratings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ratings.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightTextColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel setNumberOfLines:5];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
    }
    
    Rating *r = ratings[indexPath.row];
    [cell.textLabel setText:r.user.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f stars - \"%@\"",r.stars, r.comment]];
    [cell.detailTextLabel sizeToFit];
    return cell;
}



@end
