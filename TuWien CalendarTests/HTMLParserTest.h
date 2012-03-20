//
//  HTMLParserTest.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/15/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import <Three20/Three20.h>
#import <EventKit/EventKit.h>
#import "CalendarHelper.h"
#import "TFHpple.h"
#import "NetworkHelper.h"
#import "ASIFormDataRequest.h"

#import "ASIWebPageRequest.h"
@interface HTMLParserTest : SenTestCase{
}

@property (retain,nonatomic) TTURLDataResponse *response;
-(NSString *)makeASIQueryWithUrl:(NSString *)url1;
-(void )makeASIQueryWithUrlNoResp:(NSString *)url1;
-(NSString *)scanTissCalendar:(NSString *)response;
-(NSString *)scanTUWELCalendar:(NSString *)response;
- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;


@end
