//
//  MasterObject.h
//  techflix
//
//  Created by Akshay Easwaran on 4/26/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterObject : NSObject
+(void)save;
+(BOOL)loadSavedData;
@end
