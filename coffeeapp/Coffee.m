//
//  Coffee.m
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import "Coffee.h"

@implementation Coffee

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"identifier":    @"id",
              @"name":          @"name",
              @"detail":        @"desc",
              @"imageUrl":      @"image_url" };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if(!self) {
        return nil;
    }
    _lastUpdateDate = [NSDate date];
    
    return self;
}

@end