//
//  RTAPIClient.h
//  techflix
//
//  Created by Akshay Easwaran on 1/27/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject

+ (instancetype)sharedClient;
-(void)loginUser:(NSString*)username password:(NSString*)password completion:(void (^)(NSError *error, id object))completionBlock;
-(void)registerUser:(NSString*)username password:(NSString*)password emailAddress:(NSString*)emailAddress major:(NSString*)major completion:(void (^)(NSError *error, id object))completionBlock;
-(void)rateMovie:(NSString*)movieId rating:(NSInteger)rating completion:(void (^)(NSError *error, id object))completionBlock;
-(void)getTopMovies:(void (^)(NSError *error, NSArray *objects))completionBlock;
-(void)getTopRentals:(void (^)(NSError *error, NSArray *objects))completionBlock;
-(void)searchMovies:(NSString*)searchParam completion:(void (^)(NSError *error, NSArray *objects))completionBlock;

@end
