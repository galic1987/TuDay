
//  Created by Ivo Galic on 1/15/11.
//  Copyright 2011 Galic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Classroom.h"
#import "SettingsHelper.h"
#import "ResourcesHelper.h"

@interface CalendarHelper : NSObject {

}

+(NSString *)getEventID:(EKEvent*)event; 
+(BOOL)commit;
+(EKCalendarEventAvailabilityMask)getCalAvailabilitySupport:(NSString*)name;
+(void) displayMultiDimArray:(NSMutableArray*)array;

+(NSString*)getFormatedDate:(NSDate*)date formatter:(NSString*)format;

+(Classroom *) getClassroom:(NSString*)string;

+(NSMutableArray*) getEKEventsFromCalendarWithPrefix:(NSString*)calprefix
										 startingDay:(int)startDay
										   endingDay:(int)endDay;

+ (NSString *)stripDoubleSpaceFrom:(NSString *)str;
+ (EKEvent*) getSingleEk:(NSString*)ekidentifier;
+ (BOOL)compareTwoFirstWords:(NSString *)first second:(NSString*)second;


// calendar stuff
+ (BOOL)createNewCalendar:(NSString *)name commit:(BOOL)commit;
+ (BOOL)deleteCalendar:(NSString *)name commit:(BOOL)commit;
+ (EKCalendar *)getCalByName:(NSString*)name;

// events stuff
+ (BOOL)addEvent:(NSString *)title 
       startDate:(NSDate *)startDate 
         endDate:(NSDate *)endDate 
        location:(NSString *)location 
           notes:(NSString*)notes 
      identifier:(NSString *)identifier 
          allday:(BOOL)allday 
toCalendarWithName:(NSString*)calname
         commit:(BOOL)commit;
+(NSArray*) getEKEventsforSingleDay:(NSString*)calprefix forDate:(NSDate *)date;
@end
