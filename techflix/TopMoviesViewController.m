//
//  FirstViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TopMoviesViewController.h"
#import "APIClient.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieViewController.h"
#import "IntroViewController.h"

#import "HexColors.h"
#import "UIImageView+WebCache.h"

@interface TopMoviesViewController ()
{
    NSMutableArray *movies;
}
@end

@implementation TopMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    self.title = @"Top Movies";
    self.tableView.rowHeight = 130;
    self.tableView.estimatedRowHeight = 130;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    movies = [NSMutableArray array];
    [self refreshData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayIntro) name:@"loggedOut" object:nil];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)displayIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [self.tabBarController presentViewController:introNav animated:YES completion:nil];
}

-(void)refreshData {
    [movies removeAllObjects];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[APIClient sharedClient] getTopMovies:^(NSError *error, NSArray *objects) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[MovieViewController alloc] initWithMovie:movies[indexPath.row]] animated:YES];
}

@end
