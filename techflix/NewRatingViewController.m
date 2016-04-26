//
//  NewRatingViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/24/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "NewRatingViewController.h"
#import "Movie.h"
#import "User.h"
#import "Rating.h"

#import "STPopup.h"
#import "HexColors.h"
#import "HCSStarRatingView.h"
#import "LPlaceholderTextView.h"
#import "CSNotificationView.h"

@interface NewRatingViewController ()
{
    Movie *selectedMovie;
    Rating *existingRating;
    IBOutlet HCSStarRatingView *ratingView;
    IBOutlet LPlaceholderTextView *commentView;
}
@end

@implementation NewRatingViewController

-(instancetype)initWithMovie:(Movie *)mov {
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height)*0.8);
        selectedMovie = mov;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.popupController.containerView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    
    NSArray *ratedMovies = [User currentUser].ratedMovies;
    if ([ratedMovies containsObject:selectedMovie.identifier]) {
        self.title = @"Rating";
        NSArray *ratings = [User currentUser].allRatings;
        for (Rating *r in ratings) {
            if ([r.movie.identifier isEqual:selectedMovie.identifier]) {
                existingRating = r;
                break;
            }
        }
        
        [commentView setText:existingRating.comment];
        ratingView.value = existingRating.stars;
        [commentView setEditable:NO];
        [ratingView setUserInteractionEnabled:NO];
    } else {
        self.title = @"New Rating";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitRating)];
    }
    
    [commentView setPlaceholderText:@"Enter your comment here"];
    [commentView setFont:[UIFont systemFontOfSize:17]];
    [commentView setPlaceholderColor:[UIColor lightTextColor]];
    [commentView setTextColor:[UIColor whiteColor]];

}

-(void)submitRating {
    
    if ([[User currentUser] isLoggedIn]) {
        NSLog(@"Comment: %@ RATING: %f", commentView.text, ratingView.value);
        if (commentView.text.length == 0) {
            //change to csnotif
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"You must enter a comment in order to rate this movie."];
        } else {
            [selectedMovie rate:ratingView.value comment:commentView.text];
            [self.popupController dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newRatingMade" object:nil];
            [CSNotificationView showInViewController:self.presentingViewController style:CSNotificationViewStyleSuccess message:[NSString stringWithFormat:@"Rating for %@ saved!", selectedMovie.title]];
        }
    } else {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"You must be signed in to rate this movie."];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
