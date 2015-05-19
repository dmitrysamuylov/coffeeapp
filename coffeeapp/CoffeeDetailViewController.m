//
//  CoffeeDetailViewController.m
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import "CoffeeDetailViewController.h"
#import "Coffee.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+DateTools.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CoffeeDetailViewController ()
{
    Coffee *_coffee;
    NSMutableArray *_constraints;
    NSMutableArray *_constraintsNoImage;
}
@end

@implementation CoffeeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // configure nav bar
    [self setupNavBar];
}

- (void)setupNavBar
{
    // nav bar drop logo
    UIImageView *logo = ({
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(0, 0, 27, 27);
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:@"drip-white.png"];
        image;
    });
    self.navigationItem.titleView = logo;
    
    // set tint color to white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // share button
    UIBarButtonItem *shareButton = ({
        // custom button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 60, 20);
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"SHARE" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        // nav bar button with custom button
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
        barbutton;
    });
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)layoutUI
{
    _name = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.9 alpha:1.0];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.preferredMaxLayoutWidth = 250;
        label;
    });
    [self.view addSubview:_name];
    
    _line = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 200, 5);
        view.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.9 alpha:1.0];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.userInteractionEnabled = NO;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view;
    });
    [self.view addSubview:_line];
    
    _detail = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.9 alpha:1.0];
        label.preferredMaxLayoutWidth = 250;
        label;
    });
    [self.view addSubview:_detail];
    
    _photo = ({
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(0, 0, 300, 100);
        image.translatesAutoresizingMaskIntoConstraints = NO;
        image.contentMode = UIViewContentModeScaleAspectFit;
        image;
    });
    [self.view addSubview:_photo];
    
    _upadte = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont italicSystemFontOfSize:12.0f];
        label.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.9 alpha:1.0];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 0;
        label;
    });
    [self.view addSubview:_upadte];
    
    // apply constraints
    [self addUiConstraints];
}

- (void)addUiConstraints
{
    // name
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual           toItem:self.view attribute:NSLayoutAttributeTop   multiplier:1.0 constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual           toItem:self.view attribute:NSLayoutAttributeLeft  multiplier:1.0 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_name attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

    // line
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual toItem:_name     attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft   multiplier:1.0 constant:13]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight  multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual toItem:nil       attribute:NSLayoutAttributeNotAnAttribute  multiplier:1.0 constant:1]];
    
    // detail
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual toItem:_line     attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft   multiplier:1.0 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight  multiplier:1.0 constant:0]];
    
    // photo
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeTop      relatedBy:NSLayoutRelationEqual           toItem:_detail   attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual           toItem:self.view attribute:NSLayoutAttributeLeft   multiplier:1.0 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeRight  multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeWidth    relatedBy:NSLayoutRelationEqual           toItem:nil       attribute:NSLayoutAttributeNotAnAttribute  multiplier:1.0 constant:300]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_photo attribute:NSLayoutAttributeHeight   relatedBy:NSLayoutRelationEqual           toItem:nil       attribute:NSLayoutAttributeNotAnAttribute  multiplier:1.0 constant:300]];

    // update
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_upadte attribute:NSLayoutAttributeLeading  relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft   multiplier:1.0 constant:15]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_upadte attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight  multiplier:1.0 constant:0]];

    // update label top constraint
    if (_coffee.imageUrl.length > 0)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_upadte attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_photo attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    }
    else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_upadte attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_detail attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)share:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"TODO" message:@"Feature coming soon!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)updateForModel:(Coffee *)coffee
{
    // set model for cell
    _coffee = coffee;

    [self layoutUI];
    
    _name.text = coffee.name;
    _detail.text = coffee.detail;
    
    // download photo
    if (coffee.imageUrl.length > 0)
    {
        _photo.hidden = NO;
        [[[self signalForLoadingImage:coffee.imageUrl] deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(UIImage *image) {
             _photo.image = image;
         }];
    }
    else
    {
        _photo.hidden = YES;
    }
    
    // last updated
    _upadte.text = [@"Updated " stringByAppendingString:coffee.lastUpdateDate.timeAgoSinceNow];
}

#pragma mark - private methods

- (RACSignal *)signalForLoadingImage:(NSString *)imageUrl
{
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
}

@end
