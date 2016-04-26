//
//  User.m
//  techflix
//
//  Created by Akshay Easwaran on 2/1/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "User.h"
#import "Rating.h"
#import "MasterObject.h"

static User *currentUser = nil;
static NSMutableArray *users = nil;

@implementation User
@synthesize username,name,password,major,favoriteMovie,ratedMovies,allRatings;


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        if ([aDecoder containsValueForKey:@"name"]) {
            name = [aDecoder decodeObjectForKey:@"name"];
        } else {
            name = @"";
        }
        
        if ([aDecoder containsValueForKey:@"password"]) {
            password = [aDecoder decodeObjectForKey:@"password"];
        } else {
            password = @"";
        }
        
        if ([aDecoder containsValueForKey:@"username"]) {
            username = [aDecoder decodeObjectForKey:@"username"];
        } else {
            username = @"";
        }
        
        if ([aDecoder containsValueForKey:@"major"]) {
            major = [aDecoder decodeObjectForKey:@"major"];
        } else {
            major = @"";
        }
        
        if ([aDecoder containsValueForKey:@"favoriteMovie"]) {
            favoriteMovie = [aDecoder decodeObjectForKey:@"favoriteMovie"];
        } else {
            favoriteMovie = @"";
        }
        
        if ([aDecoder containsValueForKey:@"ratedMovies"]) {
            ratedMovies = [aDecoder decodeObjectForKey:@"ratedMovies"];
        } else {
            ratedMovies = [NSMutableArray array];
        }
        
        if ([aDecoder containsValueForKey:@"allRatings"]) {
            allRatings = [aDecoder decodeObjectForKey:@"allRatings"];
        } else {
            allRatings = [NSMutableArray array];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeObject:username forKey:@"username"];
    [aCoder encodeObject:major forKey:@"major"];
    [aCoder encodeObject:favoriteMovie forKey:@"favoriteMovie"];
    [aCoder encodeObject:ratedMovies forKey:@"ratedMovies"];
    [aCoder encodeObject:allRatings forKey:@"allRatings"];
}

+(void)initialize {
    [super initialize];
    if (!currentUser) {
        currentUser = [[User alloc] init];
    }
}

+ (instancetype)currentUser {
    return currentUser;
}

+(void)setCurrentUser:(User*)usr {
    currentUser = usr;
    if (usr) {
        [currentUser setLoggedIn:YES];
    }
}

+(NSMutableArray *)allUsers {
    return users;
}

+(void)setAllUsers:(NSMutableArray*)arr {
    users = arr;
}

+ (instancetype)newUserWithName:(NSString*)nm username:(NSString*)un password:(NSString*)pss major:(NSString*)mjr faveMovie:(NSString*)fvMov {
    User *usr = [[User alloc] initWithName:nm username:un password:pss major:mjr faveMovie:fvMov];
    [users addObject:usr];
    return usr;
}

-(instancetype)initWithName:(NSString*)nm username:(NSString*)un password:(NSString*)pss major:(NSString*)mjr faveMovie:(NSString*)fvMov {
    if (self = [super init]) {
        name = nm;
        username = un;
        password = pss;
        major = mjr;
        favoriteMovie = fvMov;
        ratedMovies = [NSMutableArray array];
    }
    return self;
}

+ (BOOL)logIn:(NSString*)un password:(NSString*)pss {
    if (un.length == 0 || pss.length == 0) {
        return false;
    }
    
    BOOL result = false;
    for (User *u in [[self class] allUsers]) {
        if ([u.username isEqualToString:un] && [u.password isEqualToString:pss]) {
            [User setCurrentUser:u];
            result = true;
            [MasterObject save];
            break;
        }
    }
    
    /*if ([un isEqualToString:@"akeaswaran"]) {
        currentUser = [User newUserWithName:@"Akshay Easwaran" username:@"akeaswaran" password:@"test" major:@"Computer Science" faveMovie:@"Skyfall"];
        result = true;
        [currentUser setLoggedIn:YES];
        [MasterObject save];
        return TRUE;
    }*/
    return result;
}

+(BOOL)signUpUserWithName:(NSString*)nm username:(NSString*)un password:(NSString*)pss major:(NSString*)mjr faveMovie:(NSString*)fvMov {
    
    if (un.length == 0 || pss.length == 0 || nm.length == 0 || mjr.length == 0 || fvMov.length == 0) {
        return false;
    }
    
    BOOL result = true;
    for (User *u in [[self class] allUsers]) {
        if ([u.username isEqualToString:un]) {
            result = false;
            break;
        }
    }
    
    if (result) {
        [User setCurrentUser:[User newUserWithName:nm username:un password:pss major:mjr faveMovie:fvMov]];
        [MasterObject save];
    }
    return result;
    
}

-(void)setLoggedIn:(BOOL)newlog {
    loggedIn = newlog;
}

-(BOOL)isLoggedIn {
    return loggedIn;
}

+(BOOL)logOut {
    [User setCurrentUser:nil];
    [MasterObject save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedOut" object:nil];
    return YES;
}

@end
