//
//  RTAPIClient.m
//  techflix
//
//  Created by Akshay Easwaran on 1/27/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "APIClient.h"
#import "User.h"

@implementation APIClient

#pragma mark - Helper methods

+ (instancetype)sharedClient {
    static APIClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[APIClient alloc] init];
    });
    return client;
}

-(void)_runDataTaskWithRequest:(NSMutableURLRequest*)request method:(NSString*)method completion:(void (^)(NSError *taskError, id object))completionBlock {

    request.HTTPMethod = method;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299) {
                    completionBlock(nil, json);
                } else {
                    completionBlock([NSError errorWithDomain:@"me.akeaswaran.techflix" code:httpResponse.statusCode userInfo:@{@"localizedDescription" : @"Bad response"}], nil);
                }
            } else {
               completionBlock(jsonError, nil);
            }
           
        } else if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock([NSError errorWithDomain:@"me.akeaswaran.techflix" code:495 userInfo:@{@"localizedDescription" : @"No response"}], nil);
        }
    }] resume];
}

-(NSMutableURLRequest*)_rottenTomatoesURLRequest:(NSString*)path parameters:(NSDictionary* _Nullable)params {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/%@", path]]];
    NSString *paramString = @"?apiKey=yedukp76ffytfuy24zsqk7f5&";
    if (params) {
        for (NSString *key in params.allKeys) {
            NSString *escapedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *escapedValue = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            paramString = [NSString stringWithFormat:@"%@%@=%@&",paramString,escapedKey,escapedValue];
        }
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@",request.URL.absoluteString,paramString];
    [request setURL:[NSURL URLWithString:urlString]];
    
    return request;
}

-(void)_post:(NSMutableURLRequest*)request completion:(void (^)(NSError *error, id object))completionBlock {
    [self _runDataTaskWithRequest:request method:@"POST" completion:completionBlock];
}

-(void)_get:(NSMutableURLRequest*)request completion:(void (^)(NSError *error, id object))completionBlock {
    [self _runDataTaskWithRequest:request method:@"GET" completion:completionBlock];
}

-(void)_put:(NSMutableURLRequest*)request completion:(void (^)(NSError *error, id object))completionBlock {
    [self _runDataTaskWithRequest:request method:@"PUT" completion:completionBlock];
}

-(void)_delete:(NSMutableURLRequest*)request completion:(void (^)(NSError *error, id object))completionBlock {
    [self _runDataTaskWithRequest:request method:@"DELETE" completion:completionBlock];
}


#pragma mark - TechFlix methods

-(void)loginUser:(NSString*)username password:(NSString*)password completion:(void (^)(NSError *error, id object))completionBlock {
    
}

-(void)registerUser:(NSString*)username password:(NSString*)password emailAddress:(NSString*)emailAddress major:(NSString*)major completion:(void (^)(NSError *error, id object))completionBlock {
    
}

-(void)rateMovie:(NSString*)movieId rating:(NSInteger)rating completion:(void (^)(NSError *error, id object))completionBlock {
    
}

#pragma mark - RottenTomatoes methods

-(void)getTopMovies:(void (^)(NSError *error, NSArray *objects))completionBlock {
    //http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=[your_api_key]&limit=1
    [self _get:[self _rottenTomatoesURLRequest:@"lists/movies/box_office.json" parameters:nil] completion:^(NSError *error, id object) {
        if (!error) {
            if ([object[@"movies"] isKindOfClass:[NSArray class]]) {
                completionBlock(nil, (NSArray*)object[@"movies"]);
            } else {
                completionBlock([NSError errorWithDomain:@"me.akeaswaran.techflix" code:909 userInfo:@{@"localizedDescription" : @"JSON object from RT API is not an array"}], nil);
            }
        } else {
            completionBlock(error, nil);
        }
    }];
}

-(void)getTopRentals:(void (^)(NSError *error, NSArray *objects))completionBlock {
    //http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=[your_api_key]&limit=1
    [self _get:[self _rottenTomatoesURLRequest:@"lists/dvds/top_rentals.json" parameters:nil] completion:^(NSError *error, id object) {
        if (!error) {
            if ([object[@"movies"] isKindOfClass:[NSArray class]]) {
                completionBlock(nil, (NSArray*)object[@"movies"]);
            } else {
                completionBlock([NSError errorWithDomain:@"me.akeaswaran.techflix" code:909 userInfo:@{@"localizedDescription" : @"JSON object from RT API is not an array"}], nil);
            }
        } else {
            completionBlock(error, nil);
        }
    }];
}

-(void)searchMovies:(NSString*)searchParam completion:(void (^)(NSError *error, NSArray *objects))completionBlock {
    //http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=[your_api_key]&q=Jack&page_limit=1
    [self _get:[self _rottenTomatoesURLRequest:@"movies.json" parameters:@{@"q" : [searchParam stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], @"page_limit" : @"10"}] completion:^(NSError *error, id object) {
        if (!error) {
            if ([object[@"movies"] isKindOfClass:[NSArray class]]) {
                completionBlock(nil, (NSArray*)object[@"movies"]);
            } else {
                completionBlock([NSError errorWithDomain:@"me.akeaswaran.techflix" code:909 userInfo:@{@"localizedDescription" : @"JSON object from RT API is not an array"}], nil);
            }
        } else {
            completionBlock(error, nil);
        }
    }];
}

@end
