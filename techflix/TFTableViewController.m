//
//  TFTableTableViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TFTableViewController.h"

#import "AppDelegate.h"

@interface TFTableViewController ()

@end

@implementation TFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedContext = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}
@end
