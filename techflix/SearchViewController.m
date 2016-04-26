//
//  SecondViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "SearchViewController.h"
#import "APIClient.h"
#import "Movie.h"
#import "MovieCell.h"

#import "HexColors.h"
#import "UIImageView+WebCache.h"



@interface SearchViewController () <UISearchBarDelegate, UIScrollViewDelegate>
{
    UISearchBar *movieSearchBar;
    BOOL searchCompleted;
    NSArray *returnedMovies;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    self.tableView.rowHeight = 50;
    self.tableView.estimatedRowHeight = 50;
    movieSearchBar = [[UISearchBar alloc] init];
    [movieSearchBar setPlaceholder:@"Search Movies"];
    [movieSearchBar setBarStyle:UIBarStyleBlack];
    [movieSearchBar setDelegate:self];
    self.navigationItem.titleView = movieSearchBar;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [movieSearchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self search:searchBar.text];
}

-(void)search:(NSString*)param {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableArray *movies = [NSMutableArray array];
    [[APIClient sharedClient] searchMovies:param completion:^(NSError *error, NSArray *objects) {
        if (!error) {
            for (NSDictionary *jsonDict in objects) {
                [movies addObject:[Movie newMovieWithDictionary:jsonDict]];
                
            }
            returnedMovies = [movies copy];
            
        } else {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return returnedMovies.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    Movie *movie = returnedMovies[indexPath.row];
    [cell.textLabel setText:movie.title];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
