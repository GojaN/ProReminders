//
//  MasterViewController.m
//  ProReminders
//
//  Created by Omer Hagopian on 6/4/13.
//  Copyright (c) 2013 Omer Hagopian. All rights reserved.
//

#import <EventKit/EventKit.h>

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    EKEventStore *_store;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _objects = [NSMutableArray new];
        _store = [[EKEventStore alloc] init];
        self.title = NSLocalizedString(@"Reminders", @"Reminders");
    }
    return self;
}
							
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *refreshEvents = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadReminders:)];
    self.navigationItem.rightBarButtonItem = refreshEvents;
    
    UIBarButtonItem *goToReminders = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goToReminders:)];
    self.navigationItem.leftBarButtonItem = goToReminders;
}

- (void)goToReminders:(id)sender {
    NSURL *remindersURL = [NSURL URLWithString:@"x-apple-reminder://"];
    if ([[UIApplication sharedApplication] canOpenURL:remindersURL]) {
        [[UIApplication sharedApplication] openURL:remindersURL];
    }
}

- (void)loadReminders:(id)sender {
    [_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
       //Load Events
        NSPredicate *reminderPredicate = [_store predicateForRemindersInCalendars:nil];
        [_store fetchRemindersMatchingPredicate:reminderPredicate completion:^(NSArray *allReminders) {
            [_objects removeAllObjects];
            [_objects addObjectsFromArray:allReminders];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }];
        
    }];
}

- (void)insertNewObject:(id)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    EKReminder *aReminder = _objects[indexPath.row];
    cell.textLabel.text = aReminder.title;
    cell.detailTextLabel.text = aReminder.hasNotes ? aReminder.notes : (aReminder.completed ? @"Completed" : @"Pending");
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    EKReminder *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
