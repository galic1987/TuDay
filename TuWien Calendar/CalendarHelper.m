
//  Created by Ivo Galic on 1/15/11.
//  Copyright 2011 Galic Design. All rights reserved.
//

#import "CalendarHelper.h"

@implementation CalendarHelper
static EKEventStore * eventStore;
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        eventStore = [[EKEventStore alloc] init];
    }
}



+(NSString *)getEventID:(EKEvent*)event{
    BOOL founduid = NO;
    NSString *string;
    NSScanner *scanner = [[NSScanner alloc]initWithString:[event notes]];
    NSCharacterSet *nl = [NSCharacterSet newlineCharacterSet];
    
    while ([scanner isAtEnd] == NO) {
        if([scanner scanString:@"Uid:" intoString:&string]){
            [scanner scanUpToCharactersFromSet:nl intoString:&string];
            founduid = YES;
            [scanner release];
            return string;
        }
        [scanner scanUpToCharactersFromSet:nl intoString:&string];
    }
    
        //alternative methods
        string = [NSString stringWithFormat:@"%@%@%@",event.title,event.location,event.startDate];
        XLog(@"Alternative UID: %@",string);
        [scanner release];
        return string;
    
}

+(BOOL)commit{
    NSError * error;
    BOOL calendar_commit = [eventStore commit:&error];
    if (error != nil || !calendar_commit) {
        XLog(@"%@",error);
    }
    return calendar_commit;
    
}

+ (EKCalendarEventAvailabilityMask)getCalAvailabilitySupport:(NSString*)name{
    EKCalendar *cal = [CalendarHelper getCalByName:name];
    return cal.supportedEventAvailabilities;
}

+ (BOOL)addEvent:(NSString *)title 
       startDate:(NSDate *)startDate 
         endDate:(NSDate *)endDate 
        location:(NSString *)location 
           notes:(NSString*)notes 
      identifier:(NSString *)identifier 
      allday:(BOOL)allday 
toCalendarWithName:(NSString*)calname
          commit:(BOOL)commit{
    
   // EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = title;
    event.location = location;
    event.notes = [NSString stringWithFormat:@"%@ \nUid:%@",notes,identifier];

    event.allDay = allday;
    event.startDate = startDate;
    event.endDate   = endDate;
    [event setCalendar:[CalendarHelper getCalByName:calname]];
    NSError *err;
    
    if([eventStore saveEvent:event span:EKSpanThisEvent error:&err]){
        XLog("added new event %@",title);
        return YES;
    }else{
        XLog("error adding events %@", err);
    }
    return NO;
}


+ (BOOL)createNewCalendar:(NSString *)name commit:(BOOL)commit{
 //   EKEventStore * eventStore = [[EKEventStore alloc] init];
    EKCalendar *ek =[EKCalendar calendarWithEventStore:eventStore];
    [ek setTitle:name];
    NSArray *ar = [eventStore sources];
    NSEnumerator *er = [ar objectEnumerator];
    EKSource *object;
    EKSource *my;
    NSString *standard= [SettingsHelper get:@"storage_type"];
    XLog(@"settings storage_type %@", [SettingsHelper get:@"storage_type"]);
    if (standard==nil) {
        standard = @"Default";
    }
    
	while (object = (EKSource *)[er nextObject]) {
       XLog("Source object listing: %@",object.title);
        if([object.title isEqualToString:standard]){
            my = object;
            break;
        }
	}
    
    if (my == nil) {
        while (object = (EKSource *)[er nextObject]) {
            XLog("Source object warning taking first one with the name: %@",object.title);
                my = object;
                break;            
        }
    }
    
    [ek setSource:my];
    NSError *error;
    if ([eventStore saveCalendar:ek commit:commit error:&error]) {
        XLog("save calendar name: %@",[ek title]);
        return YES;
    }else{
        XLog("Error adding calendar: %@", error );
        return NO;
    }
    return NO;
}

+ (BOOL)deleteCalendar:(NSString *)name commit:(BOOL)commit{
    
  //  EKEventStore * eventStore = [[EKEventStore alloc] init];
	NSEnumerator *e = [[eventStore calendars] objectEnumerator];
	EKCalendar *object;
    EKCalendar *cal = NULL;

	while (object = (EKCalendar *)[e nextObject]) {
		NSString *compare = object.title;
       // XLog(@"Calendar object ->>>>>>>> %@",object.title);
        
		if ([compare isEqual:name]) {
			XLog(@"Calendar object has name->>>>>>>> %@",object.title);
            cal = object;
            break;
		}
	}
        
    if (cal != NULL) {
        NSError *error;
        if([eventStore removeCalendar:cal commit:commit error:&error]){
            XLog("Calendar: %@ deleted!",name);
            return YES;
        }else{
            XLog("Error deleting calendar: %@", error );
        }
    }else{
        XLog("Calendar: %@ not existing!",name);      
    }
    return NO;
}



+ (EKCalendar *)getCalByName:(NSString*)name{
  //  EKEventStore * eventStore = [[EKEventStore alloc] init];    
    NSEnumerator *e = [[eventStore calendars] objectEnumerator];
    EKCalendar *object;
	while (object = (EKCalendar *)[e nextObject]) {
		NSString *compare = object.title;
        //XLog(@"Calendar object ->>>>>>>> %@",object.title);
        
		if ([compare isEqual:name]) {
			//XLog(@"found calendar with name%@",object.title);
            return object;
		}
	}
    return NULL;
}


// smart algorithmus for searching because of TISS and Wegweiser inconsistence
// 1. equals
// 2. prefix -> two words
// 3. prefix reverse -> two words
// 4. two words only
// 5. suffix (only if first 4 fail)
+(Classroom *) getClassroom:(NSString*)string{
    if (string==nil) {
        return nil;
    }    
    
    NSArray *array = [ResourcesHelper getClassrooms]; 
	XLog("incoming search %@ arrayCount %i", string, [array retainCount]);
    if (array==nil) {
        return nil;
    }
	Classroom *c;
	NSString *temp = @"";
	NSRange match;
	if (array != nil) { 
        for (int i = 0; i<[array count]; i++) { // loop all classrooms
            c = [array objectAtIndex:i];
            //XLog(@"%@", [c name]);
            
            // temp = [[c name] stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            
			temp = [CalendarHelper stripDoubleSpaceFrom:[c name]];
            if ([string isEqual:temp]) { // check other side prefix
				match = [string rangeOfString: temp];
				XLog("found match 1:1 %@ match: %i ", temp , match.length);
				return c;
				break;
			}
			
        }
        
        
		for (int i = 0; i<[array count]; i++) { // loop all classrooms
			c = [array objectAtIndex:i];
            //XLog(@"%@", [c name]);
            
            // temp = [[c name] stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            
			temp = [CalendarHelper stripDoubleSpaceFrom:[c name]]; // remove double spaces in the name of classes
			//XLog("-->match<-- -%@- -%@- ", temp, string);
			

			if ([string hasPrefix:temp]) { // check other side prefix
				match = [string rangeOfString: temp];
				if([self compareTwoFirstWords:temp second:string]){
					XLog("--found match prefix %@ match: %i ", temp , match.length);
					return c;
					break;
				}
			}
			
			if ([temp hasPrefix:string]) { // check one side prefix
				if([self compareTwoFirstWords:temp second:string]){
					match = [string rangeOfString: temp];
					XLog("--found match prefix %@ match: %i ", temp , match.length);
					return c;
					break;
				}
			}
			
			if([self compareTwoFirstWords:temp second:string]){
				XLog("--found two words %@ ", temp );
				return c;
				break;
			}

		}
		
		// this is unsure but if 3 first fail then suffix is going 
		for (int i = 0; i<[array count]; i++) { // loop for suffix
			c = [array objectAtIndex:i];
			temp = [self stripDoubleSpaceFrom:[c name]];
			//XLog("-->match<-- -%@- -%@- ", temp, string);
			if ([string hasSuffix:temp]) { // check other side prefix
				match = [string rangeOfString: temp];
					XLog("--found match suffix %@ match: %i ", temp , match.length);
					return c;
					break;
			}
			
			if ([temp hasSuffix:string]) { // check one side prefix
					match = [string rangeOfString: temp];
					XLog("--found match suffix %@ match: %i ", temp , match.length);
					return c;
					break;
			}
		}
	}
	XLog("nothing found in search");
	return nil;
}

+(void) displayMultiDimArray:(NSMutableArray*)array{
	for (int i = 0; i<[array count]; i++) {
		XLog("----> %i", i);
		for (int n = 0; n<[[array objectAtIndex:i] count]; n++) {
			EKEvent * ek;
			ek = [[array objectAtIndex:i] objectAtIndex:n];
			XLog("--------> %@ ",[ek eventIdentifier] );
			//XLog("--------> %i %@", n,[[array objectAtIndex:i] objectAtIndex:n]);
		}
	}
}

+(NSString*)getFormatedDate:(NSDate*)date formatter:(NSString*)format{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateFormat:format];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	
	[dateFormatter release];
	return formattedDateString;
	
//	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//			NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//			//NSDate *date = [NSDate date];
//			NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
//			
//			NSInteger year = [dateComponents year];
//			NSInteger month = [dateComponents month];
//			NSInteger day = [dateComponents day];
//	
//			go = day;
//			[calendar release];
//			XLog(" ->>>>>>>  Day:%i Month:%i Year:%i ",day, month,year);
}

+(NSArray*) getEKEventsforSingleDay:(NSString*)calprefix forDate:(NSDate *)date{
	NSMutableArray * relevant_calendars =  [[NSMutableArray alloc]init];
	NSEnumerator *e = [[eventStore calendars] objectEnumerator];
	EKCalendar *object;
	while (object = (EKCalendar *)[e nextObject]) {
		NSString *compare = object.title;
        //XLog(@"Calendar object ->>>>>>>> %@",object.title);
        
		if ([compare hasPrefix:calprefix]) {
			XLog(@"Calendar object has prefix->>>>>>>> %@",object.title);
			[relevant_calendars addObject:object];
		}
	}
    NSDate *endDate = [date initWithTimeInterval:86400 sinceDate:date];
    //XLog(@"getting events for %@ start %@ end", todaymid,endDate);
   // NSArray *calarray =[ NSArray arrayWithObject:[eventStore calendarWithIdentifier:calprefix]];
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:date endDate:endDate calendars: relevant_calendars]; // eventStore is an instance variable.

   [endDate release];
   [relevant_calendars release];
    
    return  [eventStore eventsMatchingPredicate:predicate];
       
}


+(EKEvent*) getSingleEk:(NSString*)ekidentifier{
    [eventStore release];
    eventStore = [[EKEventStore alloc] init];

    XLog(@"%@", [eventStore eventWithIdentifier:ekidentifier]);
    return [eventStore eventWithIdentifier:ekidentifier];
    
}

+(NSMutableArray*) getEKEventsFromCalendarWithPrefix:(NSString*)calprefix
										 startingDay:(int)startDay
										   endingDay:(int)endDay
{
	//EKEventStore * eventStore = [[EKEventStore alloc] init];
	NSMutableArray * relevant_calendars =  [[NSMutableArray alloc]init];
	NSEnumerator *e = [[eventStore calendars] objectEnumerator];
	EKCalendar *object;
	while (object = (EKCalendar *)[e nextObject]) {
		NSString *compare = object.title;
        XLog(@"Calendar object ->>>>>>>> %@",object.title);

		if ([compare hasPrefix:calprefix]) {
			XLog(@"Calendar object has prefix->>>>>>>> %@",object.title);
			[relevant_calendars addObject:object];
		}
	}
	
	// Create the predicate's start and end dates.
	CFGregorianDate gregorianStartDate, gregorianEndDate;
	CFGregorianUnits startUnits = {0, 0, startDay, 0, 0, 0};
	CFGregorianUnits endUnits = {0, 0, endDay, 0, 0, 0};
	CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
	gregorianStartDate = CFAbsoluteTimeGetGregorianDate(
														CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, startUnits),
														timeZone);
	gregorianStartDate.hour = 0;
	gregorianStartDate.minute = 0;
	gregorianStartDate.second = 0;
	gregorianEndDate = CFAbsoluteTimeGetGregorianDate(
													  
													  CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, endUnits),
													  timeZone);
	gregorianEndDate.hour = 0;
	gregorianEndDate.minute = 0;
	gregorianEndDate.second = 0;

	NSDate* startDate =   [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianStartDate, timeZone)];
	NSDate* endDate =   [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianEndDate, timeZone)];
	
	CFRelease(timeZone);
	
	// Create the predicate.
	NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:relevant_calendars]; // eventStore is an instance variable.
	[relevant_calendars release];
	
	// Fetch all events that match the predicate.
	NSArray *events = [eventStore eventsMatchingPredicate:predicate];
	
	//[self setEvents:events];
	NSMutableArray *section_events = [NSMutableArray array];
	//[section_events addObject:inside_section_events];
	
	NSEnumerator *e1 = [events objectEnumerator];
	EKEvent *object1;
	NSDate *date;
	NSString *compare = @"compare";
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateFormat:@"Ymd"];
	
	int counter = 0;
	while (object1 = (EKEvent *)[e1 nextObject]) {
		date = object1.startDate;
		NSString *formattedDateString = [dateFormatter stringFromDate:date];
		if ([compare isEqual:formattedDateString] ) {
			//[inside_section_events addObject:object1];
			[[section_events objectAtIndex:counter] addObject:object1];
			//XLog(@" %@ ",formattedDateString);
		}else {
			if(![compare isEqual:@"compare"]){
				//XLog(@" DRUGACIJE %@ ",formattedDateString);
				counter++;
				[section_events addObject:[NSMutableArray array]];
				[[section_events objectAtIndex:counter] addObject:object1];
			}else {
				[section_events addObject:[NSMutableArray array]];
				[[section_events objectAtIndex:counter] addObject:object1];
				//XLog(@"Init %@ ",formattedDateString);
			}
		}
		
		compare = formattedDateString;
		
	}
	
	//[self displayMultiDimArray:section_events];
	//[eventStore release];
	[dateFormatter release];
	return section_events;
	
}

+ (NSString *)stripDoubleSpaceFrom:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}

+ (BOOL)compareTwoFirstWords:(NSString *)first second:(NSString*)second{
	NSArray *chunks1 = [first componentsSeparatedByString: @" "];
	NSArray *chunks2 = [second componentsSeparatedByString: @" "];
	if(chunks1!=nil && chunks2!=nil){
		if([chunks1 count]>1 && [chunks2 count]>1){
			NSString * f1 = [chunks1 objectAtIndex:0];
			NSString * f2 = [chunks1 objectAtIndex:1];
			NSString * s1 = [chunks2 objectAtIndex:0];
			NSString * s2 = [chunks2 objectAtIndex:1];
			if ([f1 isEqual:s1] && [f2 isEqual:s2]) {
				return YES;
			}else {
				return NO;
			}

		}else{
			return NO;
		}
	}else {
		return NO;
	}


}



@end
