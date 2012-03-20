//
//  AlertProtocol.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/20/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertProtocol <NSObject>
-(void)changeUpdatingProcess:(id)sender string:(NSString *)string;
@end
