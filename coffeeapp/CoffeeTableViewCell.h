//
//  CoffeeTableViewCell.h
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coffee.h"

@interface CoffeeTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *detail;
@property (nonatomic, retain) UIImageView *photo;

@property (nonatomic, retain) Coffee *coffee;

- (void)updateForModel:(Coffee *)coffee;

@end
