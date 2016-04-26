//
//  MovieViewController.h
//  techflix
//
//  Created by Akshay Easwaran on 4/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TFTableViewController.h"
@class Movie;

@interface MovieViewController : TFTableViewController
-(instancetype)initWithMovie:(Movie*)mve;
@end
