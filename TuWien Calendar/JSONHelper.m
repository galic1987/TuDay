//
//  JSONHelper.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "JSONHelper.h"

@implementation JSONHelper
+ (NSMutableArray*) getPostsArray:(NSString *)response{

        XLog(@"RESP %@", response);
        NSDateFormatter *dateFormatStandard = [[NSDateFormatter alloc] init];
        [dateFormatStandard setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dict = [response JSONValue];
    NSMutableArray *array =  [NSMutableArray array];   
        for (NSDictionary* d in dict){
            // XLog("---->");
            NSString * text1 = [d objectForKey:@"content"];
            NSString * username1 = [d objectForKey:@"username"];
            NSString * date1 = [d objectForKey:@"created"];
            
            
            NSString *text = [NSString stringWithUTF8String:[text1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *username = [NSString stringWithUTF8String:[username1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *date = [NSString stringWithUTF8String:[date1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSDate *date_real = [dateFormatStandard dateFromString:date];
            Post *c = [[Post alloc]initWithUsername:username text:text date:date_real];
            //STAssertNotNil(c , @"there should be no null while parsing", nil);
            if (date_real == nil) {
                date_real = [NSDate date];
            }
            [date_real release];
            [text release];
            [username release];
            [array addObject:c];
            [c release];
            
            XLog("\nUsername:%@\nText:%@\nDate:%@\n",username,text,date_real);
        }
        [dateFormatStandard release];
        
    return array;
}
@end
