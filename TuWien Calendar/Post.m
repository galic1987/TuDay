//
//  Post.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "Post.h"

@implementation Post
@synthesize username=_username,date=_date,text=_text;

-(id)initWithUsername:(NSString*)username
                 text:(NSString *)text
                 date:(NSDate*)date{
    if (self = [super init]) {
        self.username = username;
        self.text = text;
        self.date  = date;
    }
    return self;
}

//-(void)dealloc
@end
