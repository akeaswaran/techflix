//
//  NewRatingViewController.h
//  techflix
//
//  Created by Akshay Easwaran on 4/24/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;
@interface NewRatingViewController : UIViewController
-(instancetype)initWithMovie:(Movie*)mov;
-(void)submitRating;
@end
