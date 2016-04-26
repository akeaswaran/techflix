//
//  Rating.m
//  techflix
//
//  Created by Akshay Easwaran on 4/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Rating.h"
#import "Movie.h"
#import "User.h"
#import "MasterObject.h"

#import "AutoCoding.h"

static NSMutableArray *ratings = nil;

@implementation Rating
@synthesize user,movie,comment,stars;

+ (void)initialize {
    [super initialize];
    if (!ratings)
        ratings = [NSMutableArray array];
}

+ (NSMutableArray*)allRatings {
    return ratings;
}

+(void)setRatings:(NSMutableArray*)arr {
    ratings = arr;
}

-(void)save {
    [[[self class] allRatings] addObject:self];
}

-(instancetype)initWithMovie:(Movie *)mov comment:(NSString *)cmt stars:(float)strs {
    if (self = [super init]) {
        user = [User currentUser];
        movie = mov;
        comment = cmt;
        stars = strs;
    }
    return self;
}

+ (instancetype)newRating:(Movie *)mov comment:(NSString *)cmt stars:(float)strs {
    Rating *r = [[Rating alloc] initWithMovie:mov comment:cmt stars:strs];
    [r.user.allRatings addObject:r];
    return r;
}

@end
