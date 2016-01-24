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

#import <HexColors.h>

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController *topMoviesVC = [[UINavigationController alloc] initWithRootViewController:[[TopMoviesViewController alloc] init]];
    [topMoviesVC.tabBarItem setTitle:@"Top Movies"];
    [topMoviesVC.tabBarItem setImage:[UIImage imageNamed:@"charts"]];
    
    UINavigationController *searchVC = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    [searchVC setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1]];
    
    UINavigationController *profileVC = [[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] init]];
    [profileVC.tabBarItem setTitle:@"Profile"];
    [profileVC.tabBarItem setImage:[UIImage imageNamed:@"profile"]];
    
    [self.tabBarController setViewControllers:@[topMoviesVC, searchVC, profileVC]];
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    [self setupAppearance];

    return YES;
}

-(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#F0B410"]];
    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexString:@"#F0B410"]];
    self.window.tintColor = [UIColor hx_colorWithHexString:@"#F0B410"];
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"movies" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"movies.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
