//
//  MasterObject.m
//  techflix
//
//  Created by Akshay Easwaran on 4/26/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "MasterObject.h"
#import "User.h"
#import "Movie.h"
#import "Rating.h"

#import "FCFileManager.h"

@implementation MasterObject
+ (void)save {
    NSMutableArray *users = [NSMutableArray array];
    for (User *u in [User allUsers]) {
        [users addObject:[NSKeyedArchiver archivedDataWithRootObject:u]];
    }
    
    NSMutableArray *mov = [NSMutableArray array];
    for (Movie *m in [Movie allRatedMovies]) {
        [mov addObject:[NSKeyedArchiver archivedDataWithRootObject:m]];
    }
    
    NSMutableArray *rat = [NSMutableArray array];
    for (Rating *r in [Rating allRatings]) {
        [rat addObject:[NSKeyedArchiver archivedDataWithRootObject:r]];
    }
    
    NSDictionary *appData = @{ @"movies" : mov,
                               @"users" : users,
                               @"ratings" : rat,
                               @"currentUser" : [NSKeyedArchiver archivedDataWithRootObject:[User currentUser]]
                              };
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if([FCFileManager existsItemAtPath:@"appdata.tfx"]) {
            NSError *error;
            BOOL success = [FCFileManager writeFileAtPath:@"appdata.tfx" content:[NSKeyedArchiver archivedDataWithRootObject:appData] error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) {
                    NSLog(@"Save was successful");
                } else {
                    NSLog(@"Something went wrong on save: %@", error.localizedDescription);
                }
            });
        } else {
            //Run UI Updates
            NSError *error;
            BOOL success = [FCFileManager createFileAtPath:@"appdata.tfx" withContent:[NSKeyedArchiver archivedDataWithRootObject:appData] error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) {
                    NSLog(@"Create and Save were successful");
                } else {
                    NSLog(@"Something went wrong on create and save: %@", error.localizedDescription);
                }
            });
        }
    });
}

+(BOOL)loadSavedData {
    if ([FCFileManager existsItemAtPath:@"appdata.tfx"]) {
        NSDictionary *appData = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[FCFileManager readFileAtPathAsData:@"appdata.tfx"]];
   
        NSMutableArray *users = [NSMutableArray array];
        for (NSData *u in appData[@"users"]) {
            [users addObject:[NSKeyedUnarchiver unarchiveObjectWithData:u]];
        }
        
        NSMutableArray *mov = [NSMutableArray array];
        for (NSData *m in appData[@"movies"]) {
            [mov addObject:[NSKeyedUnarchiver unarchiveObjectWithData:m]];
        }
        
        NSMutableArray *rat = [NSMutableArray array];
        for (NSData *r in appData[@"ratings"]) {
            [rat addObject:[NSKeyedUnarchiver unarchiveObjectWithData:r]];
        }
        
        [Movie setRatedMovies:mov];
        [User setAllUsers:users];
        [Rating setRatings:rat];
        
        User *usr = [NSKeyedUnarchiver unarchiveObjectWithData:appData[@"currentUser"]];
        [User setCurrentUser:usr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newLogIn" object:nil];
        return YES;
    } else {
        return NO;
    }
}
@end
