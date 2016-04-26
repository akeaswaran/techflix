//
//  Movie.h
//  techflix
//
//  Created by Akshay Easwaran on 4/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mpaaRating;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) NSString *releaseDate;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSNumber *runtime;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *rtLink;
@property (strong, nonatomic) NSString *identifier;

+(NSMutableArray*)allRatedMovies;
+(instancetype)newMovieWithDictionary:(NSDictionary*)dict;
-(void)rate:(float)stars comment:(NSString*)comment;
-(NSArray*)allRatings;
-(NSArray*)ratingsForMajor:(NSString*)mjr;
-(float)averageRating;
+(void)setRatedMovies:(NSMutableArray*)arr;

@end
