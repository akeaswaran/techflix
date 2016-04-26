//
//  Movie.m
//  techflix
//
//  Created by Akshay Easwaran on 4/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Movie.h"
#import "Rating.h"
#import "User.h"
#import "MasterObject.h"

#import "AutoCoding.h"

static NSMutableArray *allRatedMovies = nil;

@implementation Movie
@synthesize title,mpaaRating,rtLink,runtime,releaseDate,synopsis,imageUrl,identifier;


+(void)initialize {
    [super initialize];
    if (!allRatedMovies) {
        allRatedMovies = [NSMutableArray array];
    }
}

+(NSMutableArray*)allRatedMovies {
    return allRatedMovies;
}

+(void)setRatedMovies:(NSMutableArray*)arr {
    allRatedMovies = arr;
}

-(instancetype)initWithDictionary:(NSDictionary*)jsonDict {
    if (self = [super init]) {
        self.title = jsonDict[@"title"];
        self.mpaaRating = jsonDict[@"mpaa_rating"];
        self.releaseDate = jsonDict[@"release_dates"][@"theater"];
        self.imageUrl = jsonDict[@"posters"][@"original"];
        self.identifier = jsonDict[@"id"];
        self.year = jsonDict[@"year"];
        self.runtime = jsonDict[@"runtime"];
        self.synopsis = jsonDict[@"synopsis"];
        self.rtLink = jsonDict[@"links"][@"alternate"];
    }
    return self;
}

+(instancetype)newMovieWithDictionary:(NSDictionary*)jsonDict {
    return [[Movie alloc] initWithDictionary:jsonDict];
}

-(void)rate:(float)stars comment:(NSString*)comment {
    if (![[[self class] allRatedMovies] containsObject:self]) {
        [[Movie allRatedMovies] addObject:self];
    }
    
    if (![[User currentUser].ratedMovies containsObject:self]) {
        [[User currentUser].ratedMovies addObject:identifier];
    }
    
    [[Rating newRating:self comment:comment stars:stars] save];
    [MasterObject save];
}

-(float)averageRating {
    NSArray *ratings = [self allRatings];
    if (ratings.count > 0) {
        float sum = 0.0;
        for (Rating *r in ratings) {
            sum += r.stars;
        }
        return (sum / ((float)ratings.count));
    } else {
        return 0.0;
    }
}

-(NSArray*)allRatings {
    NSMutableArray *movRat = [NSMutableArray array];
    for (Rating *r in [Rating allRatings]) {
        if ([r.movie.identifier isEqual:self.identifier]) {
            [movRat addObject:r];
        }
    }
    
    return [movRat copy];
}

-(NSArray*)ratingsForMajor:(NSString*)mjr {
    NSMutableArray *movRat = [NSMutableArray array];
    for (Rating *r in [Rating allRatings]) {
        if ([r.movie.identifier isEqual:self.identifier] && [r.user.major isEqualToString:mjr]) {
            [movRat addObject:r];
        }
    }
    
    return [movRat copy];
}

@end
