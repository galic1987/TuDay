//
//  NetworkTuWienProcedure.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/20/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarHelper.h"
#import "LangHelper.h"
#import "NetworkHelper.h"
#import "ASIFormDataRequest.h"
#import "HTMLParser.h"
@interface NetworkTuWienProcedure : NSObject{
    
}
+(BOOL)isLoggedIn:(NSString *)response;
+ (NSMutableDictionary *)loginAndGetIcalTokensWith:(NSString *)string pass:(NSString *)pass;
+(NSString *)makeASIQueryWithUrl:(NSString *)url1;
+(BOOL)makeASIQueryWithUrlNoResp:(NSString *)url1;
+(NSString *)scanTissCalendar:(NSString *)response;
+(NSString *)scanTUWELCalendar:(NSString *)response;
+ (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
+(NSString*)generateTissCal:(NSString *)response;
@end
