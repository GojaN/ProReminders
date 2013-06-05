//
//  DetailViewController.h
//  ProReminders
//
//  Created by Omer Hagopian on 6/4/13.
//  Copyright (c) 2013 Omer Hagopian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) EKReminder *detailItem;

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionLabel;
@end
