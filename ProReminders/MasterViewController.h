//
//  MasterViewController.h
//  ProReminders
//
//  Created by Omer Hagopian on 6/4/13.
//  Copyright (c) 2013 Omer Hagopian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
