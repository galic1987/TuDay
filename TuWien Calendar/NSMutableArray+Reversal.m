//
//  NSMutableArray+Reversal.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/9/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "NSMutableArray+Reversal.h"

@implementation NSMutableArray (Reversal)

- (void)reverse {
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}


@end
