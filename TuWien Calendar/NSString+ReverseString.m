//
//  NSString+ReverseString.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/8/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "NSString+ReverseString.h"

@implementation NSString (ReverseString)
-(NSString *) reverseString
{
    NSUInteger len = [self length];
    NSMutableString *rtr=[NSMutableString stringWithCapacity:len];
    //        unichar buf[1];
    
    while (len > (NSUInteger)0) { 
        unichar uch = [self characterAtIndex:--len]; 
        [rtr appendString:[NSString stringWithCharacters:&uch length:1]];
    }
    return rtr;
}
@end
