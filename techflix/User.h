//
//  User.h
//  techflix
//
//  Created by Akshay Easwaran on 2/1/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding> {
    BOOL loggedIn;
}
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSString *favoriteMovie;
@property (strong, nonatomic) NSMutableArray *ratedMovies;
@property (strong, nonatomic) NSMutableArray *allRatings;
-(void)setLoggedIn:(BOOL)newlog;
-(BOOL)isLoggedIn;
+ (instancetype)newUserWithName:(NSString*)nm username:(NSString*)un password:(NSString*)pss major:(NSString*)mjr faveMovie:(NSString*)fvMov;
+ (instancetype)currentUser;
+ (void)setCurrentUser:(User*)usr;
+ (NSMutableArray *)allUsers;
+(void)setAllUsers:(NSMutableArray*)arr;
+ (BOOL)logIn:(NSString*)un password:(NSString*)pss;
+(BOOL)logOut;
+(BOOL)signUpUserWithName:(NSString*)nm username:(NSString*)un password:(NSString*)pss major:(NSString*)mjr faveMovie:(NSString*)fvMov;
@end
