//
//  AppDelegate.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "AppDelegate.h"

#import "TopMoviesViewController.h"
#import "SearchViewController.h"
#import "ProfileViewController.h"
#import "TopRentalsViewController.h"
#import "RecommendationsViewController.h"
#import "IntroViewController.h"
#import "User.h"
#import "MasterObject.h"

#import "HexColors.h"
#import "STPopup.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController *topMoviesVC = [[UINavigationController alloc] initWithRootViewController:[[TopMoviesViewController alloc] init]];
    [topMoviesVC.tabBarItem setTitle:@"Top Movies"];
    [topMoviesVC.tabBarItem setImage:[UIImage imageNamed:@"charts"]];
    
    UINavigationController *topRentals = [[UINavigationController alloc] initWithRootViewController:[[TopRentalsViewController alloc] init]];
    [topRentals.tabBarItem setTitle:@"Top Rentals"];
    [topRentals.tabBarItem setImage:[UIImage imageNamed:@"dvd"]];
    
    UINavigationController *recs = [[UINavigationController alloc] initWithRootViewController:[[RecommendationsViewController alloc] init]];
    recs.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    [recs.tabBarItem setTitle:@"Recommendations"];
    
    
    UINavigationController *searchVC = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    [searchVC setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3]];
    
    UINavigationController *profileVC = [[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] init]];
    [profileVC.tabBarItem setTitle:@"Profile"];
    [profileVC.tabBarItem setImage:[UIImage imageNamed:@"profile"]];
    
    [self.tabBarController setViewControllers:@[topMoviesVC,topRentals, recs, searchVC, profileVC]];
    [self.window setRootViewController:self.tabBarController];
    [self setupAppearance];
    [self.window makeKeyAndVisible];
    
    BOOL noFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
    BOOL loadSavedData = [MasterObject loadSavedData];
    if (!noFirstLaunch || !loadSavedData) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //display intro screen
        [self performSelector:@selector(displayIntro) withObject:nil afterDelay:0.0];
    }
    
    return YES;
}

-(void)displayIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [_tabBarController presentViewController:introNav animated:YES completion:nil];
}

-(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#eeb211"]];
    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#eeb211"]];
    self.window.tintColor = [UIColor hx_colorWithHexString:@"#eeb211"];
    
    [STPopupNavigationBar appearance].tintColor = [UIColor hx_colorWithHexString:@"#eeb211"];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleBlack;
    [[STPopupNavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


@end
