//
//  PastChatController.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/9/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
//#import "UIViewControllerDelegate.h"
//#import "LecturesCalendarHelper.h"
#import "LecturesDetailViewController.h"
#import "CalendarHelper.h"
#import "SettingsHelper.h"
#import "ResourcesHelper.h"
#import "ThemeHelper.h"
#import "LangHelper.h"
#import "NSMutableArray+Reversal.h"

@interface PastChatController : UITableViewController {
    NSMutableArray *eventsList;
    
}
@property (nonatomic, retain) NSMutableArray *eventsList;



- (NSMutableArray *) fetchEventsForToday;
//- (IBAction) addEvent:(id)sender;
- (PastChatController *)init;

@end