//
//  Movie+CoreDataProperties.h
//  techflix
//
//  Created by Akshay Easwaran on 1/24/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *movieDescription;
@property (nullable, nonatomic, retain) NSString *mpaaRating;
@property (nullable, nonatomic, retain) NSString *releaseDate;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSNumber *runtime;
@property (nullable, nonatomic, retain) NSString *synopsis;
@property (nullable, nonatomic, retain) NSString *rtLink;

@end

NS_ASSUME_NONNULL_END
