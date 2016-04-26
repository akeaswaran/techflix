//
//  RatingsListViewController.h
//  techflix
//
//  Created by Akshay Easwaran on 4/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TFTableViewController.h"
@class Movie;
@interface RatingsListViewController : TFTableViewController
-(instancetype)initWithMovie:(Movie*)mov;
@end
