//
//  TuWien_CalendarTests.m
//  TuWien CalendarTests
//
//  Created by Ivo Galic on 10/29/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

// example VEVENT
//BEGIN:VEVENT
//DTSTAMP:20111029T143502Z
//    DTSTART;TZID=Europe/Vienna:20120116T180000
//    DTEND;TZID=Europe/Vienna:20120116T200000
//SUMMARY:188.923 VU Model Engineering
//LOCATION:HS 8 Heinz Parkus
//CATEGORIES:COURSE
//DESCRIPTION:ME Vorlesung - Abendtermin
//UID:20111108T024429Z-2731370@tiss.tuwien.ac.at
//END:VEVENT


#import "TuWien_CalendarTests.h"

@implementation TuWien_CalendarTests
@synthesize response;

- (void)setUp
{
    [super setUp];
    self.response = [[[TTURLDataResponse alloc] init] autorelease];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCaldendarGet{
//    [CalendarHelper createNewCalendar:@"ivo cal" commit:YES];

//    [CalendarHelper addEvent:@"johniee" 
//                   startDate:[[NSDate alloc] init] 
//                     endDate:[[NSDate alloc] initWithTimeInterval:600 sinceDate:[[NSDate alloc] init]] 
//                    location:@"loca" 
//                       notes:@"nota blablbsa" 
//                  identifier:@"idaig234139" 
//          toCalendarWithName:@"ivo cal"];
//    
    //[CalendarHelper deleteCalendar:@"ivo cal" commit:YES];
}





- (void)testScanner
{
    return;
    [CalendarHelper deleteCalendar:@"ivo cal" commit:YES];
   [CalendarHelper createNewCalendar:@"ivo cal" commit:YES];
   // return;
    NSString * url = [[NSString alloc]initWithFormat:@"https://tuwel.tuwien.ac.at/calendar/export_execute.php?preset_what=all&preset_time=recentupcoming&username=1895261&authtoken=e528f9fe07c2698028114365745367485ed123d3"];
    TTURLRequest *request = [[[TTURLRequest alloc] initWithURL:url delegate: self] autorelease];
    [request setResponse:self.response];
    request.httpMethod = @"POST";
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    NSString *params = @"name=test";
    NSData* params2= [params dataUsingEncoding: NSASCIIStringEncoding];
    request.httpBody = params2;
    request.contentType=@"application/x-www-form-urlencoded";
    
    
    [request sendSynchronously];
    
    NSString *someString = [[NSString alloc] initWithData:[[self response]data] encoding:NSUTF8StringEncoding];
    
    // NSNumber* num = [self response] 
    
  //  XLog(@" ----------------- %@",someString);
    
    NSScanner *theScanner = [NSScanner scannerWithString:someString];
    
    // scanner type
    BOOL tuwel = YES;
    BOOL tiss = NO;

    
    // tags
    NSString *BEGIN = @"BEGIN";
    NSString *END = @"END";
    
    // Begins and ends
    NSString *VCALENDAR = @"VCALENDAR";
    NSString *VTIMEZONE = @"VTIMEZONE";
    NSString *DAYLIGHT = @"DAYLIGHT";
    NSString *STANDARD = @"STANDARD";
    NSString *VEVENT = @"VEVENT";
    
    //vevent relevant tags
    NSDate *begin_date = NULL;
    NSDate *end_date = NULL;
    NSString *title = @"";
    NSString *location = @"";
    NSString *category = @"";
    NSString *description =@"";
    
    NSString *uid = @"";

    // temp and delimiters
    NSString *temp  =@"";
    NSCharacterSet *nl = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet *doubledot = [NSCharacterSet characterSetWithCharactersInString:@":"];    
    BOOL inside_description  = NO;
    
    
    // boolean where are we now
    BOOL inside_vcalendar = NO;
    BOOL inside_vtimezone = NO;
    BOOL inside_daylight = NO;
    BOOL inside_standard = NO;
    BOOL inside_vevent = NO;
    
    // boolean logic
    BOOL bite = YES; //if u bite , then dont do it again  [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
    BOOL all_day_event = NO;

    // formatters
    NSDateFormatter *dateFormatStandard = [[NSDateFormatter alloc] init];
    
    if (tiss){
    [dateFormatStandard setDateFormat:@"yyyyMMdd'T'HHmmss"];
    }else if(tuwel){
    [dateFormatStandard setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    }
    
    XLog(@"%@" , [NSTimeZone systemTimeZone]);
    NSDateFormatter *dateFormatDay = [[NSDateFormatter alloc] init];
    [dateFormatDay setDateFormat:@"yyyyMMdd"];

    
    while ([theScanner isAtEnd] == NO) {
        bite = YES;
        
        // tags :BEGIN
        if([theScanner scanString:BEGIN intoString:NULL]){
            [theScanner scanCharactersFromSet:doubledot intoString:NULL];
            [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
            bite = NO;
            if ([temp isEqualToString:VCALENDAR]) {
                inside_vcalendar = YES;
            }else if([temp isEqualToString:VTIMEZONE]){
                inside_vtimezone = YES;
            }else if([temp isEqualToString:DAYLIGHT]){
                inside_daylight = YES;
            }else if([temp isEqualToString:STANDARD]){
                inside_standard = YES;
            }else if([temp isEqualToString:VEVENT]){
                inside_vevent = YES;
            }else{
                XLog(@"Warning unknown tag BEGIN: %@", temp);
            }
            XLog(@"BEGIN: %@", temp);

        }
        // tags :END
        if([theScanner scanString:END intoString:NULL]){
            [theScanner scanCharactersFromSet:doubledot intoString:NULL];
            [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
            bite = NO;
            if ([temp isEqualToString:VCALENDAR]) {
                inside_vcalendar = NO;
            }else if([temp isEqualToString:VTIMEZONE]){
                inside_vtimezone = NO;
            }else if([temp isEqualToString:DAYLIGHT]){
                inside_daylight = NO;
            }else if([temp isEqualToString:STANDARD]){
                inside_standard = NO;
            }else if([temp isEqualToString:VEVENT]){
                inside_vevent = NO;
                // ------------------------------> ADD
                // add event to calender:
                
              XLog(@"\n ADDING Event Begin:%@\n End:%@\n Title:%@\n Location:%@\n Description:%@\n Category:%@\n Uid:%@\n",begin_date,end_date,title,location,description,category,uid);
                NSString *notes = [[NSString alloc]initWithFormat:@"%@\n%@",category,description];
                    [CalendarHelper addEvent:title 
                                   startDate:begin_date 
                                     endDate:end_date
                                    location:location 
                                       notes:notes
                                  identifier:uid 
                                      allday:all_day_event
                          toCalendarWithName:@"ivo cal"];
                [notes release];
                
                // reset the vars
                title = @"";
               // begin_date = NULL;
               // end_date = NULL;
                location =@"";
                description = @"";
                category = @"";
                uid = @"";
                inside_description = NO;

                

                all_day_event = NO;
            }else{
                XLog(@"Warning unknown tag END: %@", temp);
            }
            XLog(@"END: %@", temp);
        }
        
        // settings
        if (!inside_vevent && inside_vcalendar && inside_vtimezone && !inside_daylight && bite) {
            [theScanner scanUpToCharactersFromSet:doubledot intoString:&temp];
            if ([temp hasPrefix:@"TZNAME"]) {
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                XLog(@"Setting timezone settings to : %@", temp);
                [dateFormatStandard setTimeZone:[NSTimeZone timeZoneWithAbbreviation:temp]];
                [dateFormatDay setTimeZone:[NSTimeZone timeZoneWithAbbreviation:temp]];
            }
        }
        
        // vevents
        if (inside_vcalendar && inside_vevent && bite) {
           // [theScanner scanUpToCharactersFromSet:doubledot intoString:NULL];

            [theScanner scanUpToCharactersFromSet:doubledot intoString:&temp];
            XLog(@"TAG: %@", temp);
            
            
            if ([temp hasPrefix:@"DTSTART"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                XLog(@"VALUE: %@", temp);
                XLog(@"Length: %i", [temp length]);

                if(tiss){
                if ([temp length]==15) {
                    // its not whole day event
                    begin_date = [dateFormatStandard dateFromString:temp];
                    XLog(@"date: %@", begin_date);
                }else if([temp length]==8){
                    // day
                    all_day_event = YES;
                    begin_date = [dateFormatDay dateFromString:temp];
                    XLog(@"day: %@", begin_date);
                }else{
                    XLog(@"Unknown date format");

                }
                }else{
                    //tuwel
                    if ([temp length]==16) {
                        // its not whole day event
                        begin_date = [dateFormatStandard dateFromString:temp];
                        XLog(@"date: %@", begin_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        begin_date = [dateFormatDay dateFromString:temp];
                        XLog(@"day: %@", begin_date);
                    }else{
                        XLog(@"Unknown date format");
                        
                    }
                }
                bite = NO;
            }
            
            if ([temp hasPrefix:@"DTEND"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                XLog(@"VALUE: %@", temp);
                XLog(@"Length: %i", [temp length]);
                
                if(tiss){
                    if ([temp length]==15) {
                        // its not whole day event
                        end_date = [dateFormatStandard dateFromString:temp];
                        XLog(@"date: %@", end_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        end_date = [dateFormatDay dateFromString:temp];
                        XLog(@"day: %@", end_date);
                    }else{
                        XLog(@"Unknown date format");
                        
                    }
                }else{
                    //tuwel
                    if ([temp length]==16) {
                        // its not whole day event
                        end_date = [dateFormatStandard dateFromString:temp];
                        XLog(@"tuwel end date: %@", end_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        end_date = [dateFormatDay dateFromString:temp];
                        XLog(@"tuwel day: %@", end_date);
                    }else{
                        XLog(@"Unknown date format");
                        
                    }
                }
                bite = NO;
            }
            
            if ([temp hasPrefix:@"SUMMARY"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&title];
                XLog(@"TITLE: %@", title);
              //  title = [[NSString alloc]initWithString:temp];
                bite = NO;
            }
            
            if ([temp hasPrefix:@"LOCATION"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&location];
                XLog(@"LOCATION: %@", location);
              //  location = [[NSString alloc]initWithString:temp];
                bite = NO;
            }
            
            if ([temp hasPrefix:@"CATEGORIES"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&category];
                XLog(@"CATEGORY: %@", category);
              //  category = [[NSString alloc]initWithString:temp];
                bite = NO;
            }
            
            if ([temp hasPrefix:@"DESCRIPTION"]) {
                inside_description = YES; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&description];
                XLog(@"DESCRIPTION: %@", description);
              //  description = [[NSString alloc]initWithString:temp];
                bite = NO;
            }
            
            if ([temp hasPrefix:@"UID"]) {
                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&uid];
                XLog(@"UID: %@", uid);
               // uid = [[NSString alloc]initWithString:temp];
                bite = NO;
            }
            
            if ([temp hasPrefix:@"CLASS"] || [temp hasPrefix:@"LAST-MODIFIED"] || [temp hasPrefix:@"DTSTAMP"]) {
                inside_description = NO; // inside description can be multiline so we need hack
            }
            
            if (inside_description && bite) {
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                description = [NSString stringWithFormat:@"%@%@", description, temp]; 
                bite = NO;
            }

        }
            
        
        
        // new line go , ONLY if not bite        
        if (bite) {
            [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
        }       
        

    }

    
}

@end
