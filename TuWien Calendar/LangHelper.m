//
//  LangHelper.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/27/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "LangHelper.h"

@implementation LangHelper
+(NSString *)get:(NSString*)key{
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:@"InfoPlist"];
}
@end
