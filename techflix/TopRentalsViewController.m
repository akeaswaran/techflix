//
//  TopRentalsViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TopRentalsViewController.h"
#import "APIClient.h"
#import "Movie.h"
#import "MovieViewController.h"
#import "MovieCell.h"

#import "HexColors.h"
#import "UIImageView+WebCache.h"

@interface TopRentalsViewController ()
{
    NSMutableArray *movies;
}
@end

@implementation TopRentalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    self.title = @"Top Rentals";
    self.tableView.rowHeight = 130;
    self.tableView.estimatedRowHeight = 130;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    movies = [NSMutableArray array];
    [self refreshData];
    [self.tableView reloadData];
    
}

-(void)refreshData {
    [movies removeAllObjects];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[APIClient sharedClient] getTopRentals:^(NSError *error, NSArray *objects) {
        if (!error) {
            for (NSDictionary *jsonDict in objects) {
                Movie *movie = [Movie newMovieWithDictionary:jsonDict];
                [movies addObject:movie];
            }
            
        } else {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.refreshControl endRefreshing];
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return movies.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
    cell.selectedBackgroundView = bgView;
    Movie *movie = movies[indexPath.row];
    [cell.titleLabel setText:movie.title];
    [cell.detailLabel setText:movie.synopsis];
    [cell.detailLabel sizeToFit];
    [cell.thumbnailView sd_setImageWithURL:[NSURL URLWithString:movie.imageUrl]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //left intentionally empty for row actions to work
}

-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Rate" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[favAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[MovieViewController alloc] initWithMovie:movies[indexPath.row]] animated:YES];
}


@end
