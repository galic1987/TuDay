//
//  JSONHelper.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "CalendarHelper.h"
#import "TFHpple.h"
#import "NetworkHelper.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "Post.h"

@interface JSONHelper : NSObject
+ (NSMutableArray*) getPostsArray:(NSString *)response;

@end
