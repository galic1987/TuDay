//
//  LecturesDetailViewController.h
//  TUGuide
//
//  Created by Ivo Galic
//  Copyright Galic Design All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "LecturesDetailView.h"
//#import "UIViewControllerDelegate.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
//#import "LecturesCalendarHelper.h"
//#import "MapListDetailView.h"
//#import "LocationDetailViewController.h"
#import "Classroom.h"
#import "CalendarHelper.h"
#import "TableDragRefreshController.h"
#import "LangHelper.h"

@interface LecturesDetailViewController : EKEventViewController  {
	Classroom *classroom;
	//NSMutableArray *classrooms;
     int classroom_row;
     int discuss_row;
     int nr_rows_in_section;
}

//@property (nonatomic, assign) id <UIViewControllerDelegate> delegate2;
//@property (nonatomic, retain) NSMutableArray *classrooms;
@property (nonatomic, retain) Classroom *classroom;
- (id)initWithLocation:(NSString*)location;
//- (LecturesDetailViewController *)initWithClassrooms:(NSMutableArray*)classes;
@end


