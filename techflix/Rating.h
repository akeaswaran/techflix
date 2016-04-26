//
//  Rating.h
//  techflix
//
//  Created by Akshay Easwaran on 4/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class Movie;
@interface Rating : NSObject
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) NSString *comment;
@property (nonatomic) float stars;
-(void)save;
+ (NSMutableArray*)allRatings;
+(void)setRatings:(NSMutableArray*)arr;
+(instancetype)newRating:(Movie*)mov comment:(NSString*)cmt stars:(float)strs;
@end
