//
//  TFTableTableViewController.h
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@end
