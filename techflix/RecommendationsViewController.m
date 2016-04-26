//
//  RecommendationsViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RecommendationsViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieViewController.h"
#import "Rating.h"
#import "User.h"

#import "HexColors.h"
#import "UIImageView+WebCache.h"

@interface RecommendationsViewController () <UISearchBarDelegate, UIScrollViewDelegate>
{
    NSMutableArray *movies;
    UISearchBar *movieSearchBar;
}
@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.title = @"Recommendations";
    self.tableView.rowHeight = 130;
    self.tableView.estimatedRowHeight = 130;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    movies = [NSMutableArray array];
    [self refreshData: nil];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMovieData) name:@"newRatingMade" object:nil];
    
    movieSearchBar = [[UISearchBar alloc] init];
    [movieSearchBar setPlaceholder:@"Filter by Major"];
    [movieSearchBar setBarStyle:UIBarStyleBlack];
    [movieSearchBar setDelegate:self];
    self.navigationItem.titleView = movieSearchBar;
    
}

-(void)reloadMovieData {
    [self refreshData:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [movieSearchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self refreshData:searchBar.text];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshData:(NSString*)param {
    [movies removeAllObjects];
    movies = [Movie allRatedMovies];
    NSMutableArray *mov = [movies mutableCopy];
    
    for (Movie *m in movies) {
        if ([[User currentUser].ratedMovies containsObject:m]) {
            if ([mov containsObject:m]) {
                [mov removeObject:m];
            }
        }
    }
    
    if (param) {
        for (Movie *m in movies) {
            for (Rating *r in [m allRatings]) {
                if ([r.user.major containsString:param] && ![r.user.username isEqualToString:[User currentUser].username]) {
                    NSLog(@"R->USER: %@ CURRENTUSER: %@", r.user.username, [User currentUser].username);
                    if (![mov containsObject:m]) {
                        [mov addObject:m];
                    }
                }
            }
        }
        
    }
    movies = mov;
    
    [movies sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Movie *a = (Movie*)obj1;
        Movie *b = (Movie*)obj2;
        float aAvg = [a averageRating];
        float bAvg = [b averageRating];
        return aAvg > bAvg ? -1 : aAvg == bAvg ? 0 : 1;
    }];
    [self.tableView reloadData];
    NSLog(@"RATED MOVIES: %ld", movies.count);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (movies.count > 5) {
        return 5;
    } else {
        return movies.count;
    }
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
