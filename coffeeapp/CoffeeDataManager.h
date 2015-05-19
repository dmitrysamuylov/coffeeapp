//
//  CoffeeDataManager.h
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoffeeDataManager : NSObject

@property (nonatomic, retain) NSArray *coffees;

+(CoffeeDataManager*)manager;

- (void)getAllCoffeesWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end