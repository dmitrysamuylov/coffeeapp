//
//  CoffeeTableViewCell.m
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import "CoffeeTableViewCell.h"
#import "CoffeeDataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation CoffeeTableViewCell
{
    Coffee *_coffee;
    NSMutableArray *_constraints;
    NSMutableArray *_constraintsNoImage;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        _constraints = [NSMutableArray new];
        _constraintsNoImage = [NSMutableArray new];
        [self layoutUI];
    }
    
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    // update constrains based on if we have an image
    if(_coffee.imageUrl.length > 0)
    {
        [NSLayoutConstraint deactivateConstraints:_constraintsNoImage];
        [NSLayoutConstraint activateConstraints:_constraints];
    }
    else
    {
        [NSLayoutConstraint deactivateConstraints:_constraints];
        [NSLayoutConstraint activateConstraints:_constraintsNoImage];
    }
}

- (void)layoutUI
{
    // table cell settings
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    
    // add our UI controls
    _name = ({
        UILabel *label = [UILabel new];
        [label setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.9 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:18]];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [label setPreferredMaxLayoutWidth:200.0];
        label;
    });
    [self.contentView addSubview:_name];
    
    _detail = ({
        UILabel *label = [UILabel new];
        [label setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.9 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTranslatesAutoresizingMaskIntoConstraints: NO];
        [label setNumberOfLines:2];
        [label setPreferredMaxLayoutWidth:200];
        label;
    });
    [self.contentView addSubview:_detail];
    
    _photo = ({
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(0, 0, 300, 100);
        [image setTranslatesAutoresizingMaskIntoConstraints:NO];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        image;
    });
    [self.contentView addSubview:_photo];
    
    // apply constraints
    [self addUiConstraints];
}

- (void)addUiConstraints
{
    // name
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual           toItem:self.contentView attribute:NSLayoutAttributeTop   multiplier:1.0 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual           toItem:self.contentView attribute:NSLayoutAttributeLeft  multiplier:1.0 constant:15]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    // detail
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual toItem:_name            attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft   multiplier:1.0 constant:15]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight  multiplier:1.0 constant:0]];
    
    // photo
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_detail attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    contraint = [NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    contraint = [NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    contraint = [NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    contraint = [NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    // cell height with image shown
    contraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_photo attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    contraint.priority = 999;
    [self.contentView addConstraint:contraint];
    [_constraints addObject:contraint];
    
    // cell height with image hidden
    contraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_detail attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    contraint.priority = 999;
    [self.contentView addConstraint:contraint];
    [_constraintsNoImage addObject:contraint];
}

- (void)updateForModel:(Coffee *)coffee
{
    // set model for cell
    _coffee = coffee;
    
    // set labels
    _name.text = coffee.name;
    _detail.text = coffee.detail;

    // photo
    if (coffee.imageUrl.length > 0)
    {
        // download and show if we have a url
         _photo.hidden = NO;
        [_photo sd_setImageWithURL:[NSURL URLWithString:coffee.imageUrl] placeholderImage:[UIImage imageNamed:@"logo.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             _photo.image = image;
        }];
    }
    else
    {
        // otherwise hide
        _photo.hidden = YES;
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

@end
