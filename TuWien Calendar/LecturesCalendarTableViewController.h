//
//  LecturesCalendarTableViewController.h
//  TUGuide
//
//  Created by Ivo Galic on 1/13/11.
//  Copyright 2011 Galic Design. All rights reserved.
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
	
@interface LecturesCalendarTableViewController : UITableViewController {
	LecturesDetailViewController *detailViewController;
	//NSMutableArray *classrooms;
    NSMutableArray *eventsList;

	}
//@property (nonatomic, assign) NSMutableArray *classrooms;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) LecturesDetailViewController *detailViewController;


	
- (NSMutableArray *) fetchEventsForToday;
//- (IBAction) addEvent:(id)sender;
- (LecturesCalendarTableViewController *)init;

@end
	
