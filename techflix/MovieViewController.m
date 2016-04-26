//
//  MovieViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "MovieViewController.h"
#import "Movie.h"
#import "NewRatingViewController.h"
#import "RatingsListViewController.h"

#import "UIImageView+WebCache.h"
#import "HexColors.h"
#import "STPopup.h"

@interface TFMovieHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TFMovieHeaderView
@end

@interface MovieViewController ()
{
    Movie *selectedMovie;
    STPopupController *popupController;
    IBOutlet TFMovieHeaderView *headerView;
}
@end

@implementation MovieViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

-(instancetype)initWithMovie:(Movie*)mve {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedMovie = mve;
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Movie";
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    headerView.titleLabel.text = selectedMovie.title;
    [headerView.thumbnailView sd_setImageWithURL:[NSURL URLWithString:selectedMovie.imageUrl]];
    [headerView.ratingLabel setText:selectedMovie.mpaaRating];
    [headerView.yearLabel setText:[selectedMovie.year stringValue]];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(rate)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMovieView) name:@"newRatingMade" object:nil];
}

-(void)reloadMovieView {
    [self.tableView reloadData];
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)rate {
    popupController = [[STPopupController alloc] initWithRootViewController:[[NewRatingViewController alloc] initWithMovie:selectedMovie]];
    [popupController.navigationBar setDraggable:YES];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //view in safari
        return [selectedMovie.synopsis boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]} context:nil].size.height + 150;
    } else {
        return 45;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Details";
    } else if (section == 2) {
        return @"Ratings";
    } else {
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2; //runtime & release date
    } else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpperCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UpperCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.detailTextLabel setTextColor:[UIColor lightTextColor]];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Runtime"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ minutes", [selectedMovie.runtime stringValue]]];
        } else {
            [cell.textLabel setText:@"Release Date"];
            [cell.detailTextLabel setText:selectedMovie.releaseDate];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpperCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpperCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                [cell.textLabel setNumberOfLines:0];
            }
            
            [cell.textLabel setText:selectedMovie.synopsis];
            [cell.textLabel sizeToFit];
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpperCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpperCell"];
                UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
                [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
                cell.selectedBackgroundView = bgView;
                cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            [cell.textLabel setText:@"View in Safari"];
            
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvgRatingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AvgRatingCell"];
                cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.textLabel setText:@"Average Rating"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f stars", [selectedMovie averageRating]]];
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RatingCell"];
                UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
                [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
                cell.selectedBackgroundView = bgView;
                cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            [cell.textLabel setText:@"View all Ratings"];
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        //view in safari
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedMovie.imageUrl]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        [self.navigationController pushViewController:[[RatingsListViewController alloc] initWithMovie:selectedMovie] animated:YES];
    }
}


@end
