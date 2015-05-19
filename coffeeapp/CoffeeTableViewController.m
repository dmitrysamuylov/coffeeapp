//
//  CoffeeTableViewController.m
//  coffeeapp
//
//  Created by Dmitry Samuylov on 5/17/15.
//  Copyright (c) 2015 Dima Interactive. All rights reserved.
//

#import "CoffeeTableViewController.h"
#import "CoffeeDataManager.h"
#import "Coffee.h"
#import "CoffeeDetailViewController.h"
#import "CoffeeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CoffeeTableViewController ()
{
    NSArray *_coffees;
}
@end

@implementation CoffeeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // nav bar drop logo
    UIImageView *logo = ({
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:@"drip-white.png"];
        image;
    });
    self.navigationItem.titleView = logo;
    
    // tableview settings
    [self.tableView registerClass:[CoffeeTableViewCell class] forCellReuseIdentifier:@"CoffeeCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    // retrieve archived data
    NSDictionary *storedcoffees = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForArchiving]];
    if (storedcoffees)
    {
        [self setCoffees:storedcoffees[@"coffees"]];
    }
    else
    {
        // fetch coffees data
        @weakify(self)
        [[CoffeeDataManager manager] getAllCoffeesWithSuccess:^{
            @strongify(self)
            // success
            [self setCoffees:[CoffeeDataManager manager].coffees];
            [self saveToDisk];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            // failure
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Sorry, there's was a problem retrieving Coffee information." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_coffees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coffee *coffee = (Coffee *)_coffees[indexPath.row];
    
    CoffeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeCell" forIndexPath:indexPath];
    [cell updateForModel:coffee];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coffee *coffee = (Coffee *)_coffees[indexPath.row];
    
    CoffeeDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
    [detailViewController updateForModel:coffee];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - private methods

- (void)setCoffees:(NSArray *)coffees
{
    _coffees = coffees;
}

- (void)saveToDisk
{
    // persist
    NSMutableDictionary *root = @{ @"coffees" : _coffees }.mutableCopy;
    [NSKeyedArchiver archiveRootObject:root toFile:[self pathForArchiving]];
}

- (NSString *)pathForArchiving
{
    NSArray *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = nil;
    
    if (documentDir)
    {
        path = [documentDir objectAtIndex:0];
    }
    
    return [NSString stringWithFormat:@"%@/%@", path, @"coffee.data"];
}

@end
