//
//  ScannerIcalParser.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 10/30/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "ScannerIcalParser.h"

@implementation ScannerIcalParser
@synthesize added;
@synthesize main;


-(void)dealloc{
   // TT_RELEASE_SAFELY(response);
}

- (BOOL)updateCalwithName:(NSString*)calendar
                 withLink:(NSString *)link
                  calType:(NSString *)calType;
{

    added = 0;
    TTURLDataResponse *response = [[[TTURLDataResponse alloc]init]autorelease];
    TTURLRequest *request = [[[TTURLRequest alloc] initWithURL:link delegate: self] autorelease];
    [request setResponse:response];
    request.httpMethod = @"GET";
    request.cachePolicy = TTURLRequestCachePolicyNoCache;
    request.contentType=@"application/x-www-form-urlencoded";
    
    
    [request sendSynchronously];
    
    NSString *someString = [[[NSString alloc] initWithData:[response data] encoding:NSUTF8StringEncoding]autorelease];
    
    // NSNumber* num = [self response] 
    
     XLog(@" ----------------- %@",someString);
    
    NSScanner *theScanner = [NSScanner scannerWithString:someString];
    
    BOOL tuwel = NO;
    BOOL tiss = NO;
    // scanner type
    if([calType isEqualToString:@"tuwel"]){
        tuwel = YES;
    }else{
        tiss = YES;
    }

    int total_file_length = (int)[someString length];

    
    
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
    
    // 
    
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
            if ([temp isEqualToString:VEVENT]) {
                inside_vevent = YES;
            }else if([temp isEqualToString:VTIMEZONE]){
                inside_vtimezone = YES;
            }else if([temp isEqualToString:DAYLIGHT]){
                inside_daylight = YES;
            }else if([temp isEqualToString:STANDARD]){
                inside_standard = YES;
            }else if([temp isEqualToString:VCALENDAR]){
                inside_vcalendar = YES;
            }else{
                XLog(@"Warning unknown tag BEGIN: %@", temp);
            }
            XLog(@"BEGIN: %@", temp);
            bite = NO;
            continue;
        }
        // tags :END
        if([theScanner scanString:END intoString:NULL]){
            [theScanner scanCharactersFromSet:doubledot intoString:NULL];
            [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
            if ([temp isEqualToString:VEVENT]) {
                inside_vevent = NO;
                // ------------------------------> ADD
                // add event to calender:
                
                
                if (tiss) {
                
                if ([uid length]> 2) {
                    NSArray *arr = [uid componentsSeparatedByString:@"-"];
                    if(sizeof(arr) > 2){
                        uid = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
                    }
                    uid = [uid stringByReplacingOccurrencesOfString:@"." withString:@"-"];

                }else{
                    // loc + date
                    uid = [NSString stringWithFormat:@"%@%@",location,begin_date];
                }
                
                }else if(tuwel){
                    uid = [uid stringByReplacingOccurrencesOfString:@"." withString:@"-"];

                }
                //XLog(@"\n ADDING Event Begin:%@\n End:%@\n Title:%@\n Location:%@\n Description:%@\n Category:%@\n Uid:%@\n Calendar name: %@",begin_date,end_date,title,location,description,category,uid,calendar);

                
                NSString *notes = [[NSString alloc]initWithFormat:@"%@\n%@",category,description];
                if([CalendarHelper addEvent:title 
                                  startDate:begin_date 
                                    endDate:end_date
                                   location:location 
                                      notes:notes
                                 identifier:uid 
                                     allday:all_day_event
                         toCalendarWithName:calendar
                                     commit:NO]){
                    added = added + 1;
                    NSString *show;
                    float location_of_scanner = (float)[theScanner scanLocation];
                    float calculation = (float)((location_of_scanner/total_file_length)*100);
                    if (calculation>=100) {
                        calculation = 100.0f;
                    }
//                    XLog(@"length %i", [someString length]);
//                    XLog(@"scanner loc %i", [theScanner scanLocation]);
                  // XLog(@"calc %.2f", (float)(location_of_scanner/total_file_length));
                    if (tiss) {
                    show = [NSString stringWithFormat:@"%@ %i (%.1f%%)",[LangHelper get:@"CONN_LOGGED_PARSING_TISS"] , added,calculation ];

                    }else if(tuwel){
                       show = [NSString stringWithFormat:@"%@ %i (%.1f%%)",[LangHelper get:@"CONN_LOGGED_PARSING_TUWEL"] , added,calculation ]; 
                    }
                    [main changeUpdatingProcess:self string:show];
                }
                
                [notes release];
                
                // reset the vars
                title = @"";
                // begin_date = NULL;
                // end_date = NULL;
                location =@"";
                description = @"";
                category = @"";
                uid = @"";
                all_day_event = NO;     
                
            }else if([temp isEqualToString:VTIMEZONE]){
                inside_vtimezone = NO;
            }else if([temp isEqualToString:DAYLIGHT]){
                inside_daylight = NO;
            }else if([temp isEqualToString:STANDARD]){
                inside_standard = NO;
            }else if([temp isEqualToString:VCALENDAR]){
                inside_vcalendar = NO;
            }else{
                XLog(@"Warning unknown tag END: %@", temp);
            }
            bite = NO;
            continue;
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
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                //XLog(@"VALUE: %@", temp);
                //XLog(@"Length: %i", [temp length]);
                
                if(tiss){
                    if ([temp length]==15) {
                        // its not whole day event
                        begin_date = [dateFormatStandard dateFromString:temp];
                        //XLog(@"date: %@", begin_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        begin_date = [dateFormatDay dateFromString:temp];
                        //XLog(@"day: %@", begin_date);
                    }else{
                        //XLog(@"Unknown date format");
                        
                    }
                }else{
                    //tuwel
                    if ([temp length]==16) {
                        // its not whole day event
                        begin_date = [dateFormatStandard dateFromString:temp];
                        //XLog(@"date: %@", begin_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        begin_date = [dateFormatDay dateFromString:temp];
                        //XLog(@"day: %@", begin_date);
                    }else{
                        //XLog(@"Unknown date format");
                        
                    }
                }
                bite = NO;
                continue;
            }
            
            if ([temp hasPrefix:@"DTEND"]) {
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                //XLog(@"VALUE: %@", temp);
                //XLog(@"Length: %i", [temp length]);
                
                if(tiss){
                    if ([temp length]==15) {
                        // its not whole day event
                        end_date = [dateFormatStandard dateFromString:temp];
                        //XLog(@"date: %@", end_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        end_date = [dateFormatDay dateFromString:temp];
                        //XLog(@"day: %@", end_date);
                    }else{
                        //XLog(@"Unknown date format");
                        
                    }
                }else{
                    //tuwel
                    if ([temp length]==16) {
                        // its not whole day event
                        end_date = [dateFormatStandard dateFromString:temp];
                        //XLog(@"tuwel end date: %@", end_date);
                    }else if([temp length]==8){
                        // day
                        all_day_event = YES;
                        end_date = [dateFormatDay dateFromString:temp];
                        //XLog(@"tuwel day: %@", end_date);
                    }else{
                        //XLog(@"Unknown date format");
                        
                    }
                }
                bite = NO;
                continue;

            }
            
            if ([temp hasPrefix:@"SUMMARY"]) {
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&title];
                //XLog(@"TITLE: %@", title);
                //  title = [[NSString alloc]initWithString:temp];
                bite = NO;
                continue;
            }
            
            if ([temp hasPrefix:@"LOCATION"]) {
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&location];
                //XLog(@"LOCATION: %@", location);
                //  location = [[NSString alloc]initWithString:temp];
                bite = NO;
                continue;
            }
            
            if ([temp hasPrefix:@"CATEGORIES"]) {
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&category];
                //XLog(@"CATEGORY: %@", category);
                //  category = [[NSString alloc]initWithString:temp];
                bite = NO;
                continue;
            }
            
            if ([temp hasPrefix:@"DESCRIPTION"]) {
//                inside_description = YES; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&description];
                
                XLog(@"DESCRIPTION: %@", description);
                XLog(@"DESCRIPTION le: %i", [description length]);
                
                
                if ([description length]>60) {
                    [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                    description = [NSString stringWithFormat:@"%@%@", description, temp];
                    while ([temp length]>60) {
                        [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
                        description = [NSString stringWithFormat:@"%@%@", description, temp];
                    }
                
                    bite = NO;
                    continue;
                }else{
                //  description = [[NSString alloc]initWithString:temp];
                bite = NO;
                continue;
                }
            }
            
            if ([temp hasPrefix:@"UID"]) {
//                inside_description = NO; // inside description can be multiline so we need hack
                [theScanner scanCharactersFromSet:doubledot intoString:NULL];
                [theScanner scanUpToCharactersFromSet:nl intoString:&uid];
                XLog(@"UID: %@", uid);
                // uid = [[NSString alloc]initWithString:temp];
                bite = NO;
                continue;

            }
            
//            if ([temp hasPrefix:@"CLASS"] || [temp hasPrefix:@"LAST-MODIFIED"] || [temp hasPrefix:@"DTSTAMP"] || [temp hasPrefix:@"UID"]) {
////                inside_description = NO; // inside description can be multiline so we need hack
//            }
            
//            if (inside_description && bite) {
//                [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
//                description = [NSString stringWithFormat:@"%@%@", description, temp]; 
//                bite = NO;
//                continue;
//
//            }
            
        }
        
        
        
        // new line go , ONLY if not bite        
        if (bite) {
            [theScanner scanUpToCharactersFromSet:nl intoString:&temp];
        }       
        
        
    }
    [CalendarHelper commit];
    [dateFormatStandard release];
    [dateFormatDay release];
    //[theScanner release];
    return YES;

}

@end
