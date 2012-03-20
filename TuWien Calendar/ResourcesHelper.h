//
//  ResourcesHelper.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/7/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsHelper.h"
#import "NetworkHelper.h"
#import "ASIHTTPRequest.h"
@interface ResourcesHelper : NSObject <ASIHTTPRequestDelegate>
+(NSMutableArray *)getClassrooms;
+(void)getData;
@end
