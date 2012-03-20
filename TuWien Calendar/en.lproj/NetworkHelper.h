//
//  NetworkHelper.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/15/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//
#import "CalendarHelper.h"
#import "NetworkHelper.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface NetworkHelper : NSObject
+ (BOOL)clearCookiesByUrl:(NSString *)url;
+ (void)listCookies;
+ (void)dropAllCookies;
+ (NSString *) allCookiesByUrl:(NSString *)url;
+ (NSMutableArray*) getClassromsArray:(NSString *)url;

@end
