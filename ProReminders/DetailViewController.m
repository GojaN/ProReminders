//
//  DetailViewController.m
//  ProReminders
//
//  Created by Omer Hagopian on 6/4/13.
//  Copyright (c) 2013 Omer Hagopian. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSMutableString *reminderData = [NSMutableString new];
        [reminderData appendFormat:@"Title: %@\n", self.detailItem.title];
        [reminderData appendFormat:@"Calendar: %@\n", self.detailItem.calendar];
        [reminderData appendFormat:@"Location: %@\n", self.detailItem.location];
        [reminderData appendFormat:@"C.Date: %@\n", [self.detailItem.creationDate description]];
        [reminderData appendFormat:@"M.Date: %@\n", [self.detailItem.lastModifiedDate description]];
        [reminderData appendFormat:@"TimeZone: %@\n", [self.detailItem.timeZone description]];
        [reminderData appendFormat:@"URL: %@\n", [self.detailItem.URL absoluteString]];
        [reminderData appendFormat:@"Notes: %@\n", self.detailItem.notes];
        [reminderData appendFormat:@"Alarms: %@\n", [self.detailItem.alarms description]];
        [reminderData appendFormat:@"Start Date Comp: %@\n", [self.detailItem.startDateComponents description]];
        [reminderData appendFormat:@"Due Date Comp: %@\n", [self.detailItem.dueDateComponents description]];
        [reminderData appendFormat:@"Completed: %d\n", self.detailItem.completed];
        [reminderData appendFormat:@"Completed Date: %@\n", [self.detailItem.completionDate description]];
        self.detailDescriptionLabel.text = reminderData;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
