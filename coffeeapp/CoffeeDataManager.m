//
//  CoffeeDataManager.m
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import "CoffeeDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Coffee.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation CoffeeDataManager

+ (CoffeeDataManager*)manager
{
    static CoffeeDataManager *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)getAllCoffeesWithSuccess:(void(^)())success failure:(void(^)(NSError *error))failure
{
    @weakify(self);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"WuVbkuUsCXHPx3hsQzus4SE" forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://coffeeapi.percolate.com/api/coffee/" parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
        @strongify(self);
        // success
        NSMutableArray *results = [NSMutableArray array];
        
        for(NSDictionary *values in response)
        {
            NSError *error;
            Coffee *coffee = [MTLJSONAdapter modelOfClass:[Coffee class] fromJSONDictionary:values error:&error];
            [results addObject:coffee];
        }        
        self.coffees = results;
        
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure(error);
    }];
}

@end