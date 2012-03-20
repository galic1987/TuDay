//
//  SettingsHelper.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/26/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsHelper : NSObject
+ (NSString *)get:(NSString*)settings;
+ (void)set:(NSString*)settings forKey:(NSString*)key;
+ (void)registerDefaultsFromSettingsBundle;
@end
