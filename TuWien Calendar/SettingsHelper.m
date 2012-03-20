//
//  SettingsHelper.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/26/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "SettingsHelper.h"

@implementation SettingsHelper

static NSUserDefaults *prefs;
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        //[self registerDefaultsFromSettingsBundle];
        [NSUserDefaults initialize];
        prefs= [NSUserDefaults standardUserDefaults];
    }
}

+ (NSString *)get:(NSString*)settings{
    NSString * sett = [prefs stringForKey:settings];
    if (sett == nil) {
        XLog(@"Settings for %@ key are null warning", settings);
    }
    return sett;
}

+ (void)set:(NSString*)settings forKey:(NSString*)key{
    [prefs setObject:settings forKey:key];
}

+ (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    if ([self get:@"cal_name"] == nil) {
        [self set:@"Tu Wien" forKey:@"cal_name"];
    }
    
    if ([self get:@"storage_type"] == nil) {
        [self set:@"Default" forKey:@"storage_type"];
    }
    
    if ([self get:@"json_package"] == nil) {
        [self set:@"http://galic-design.com/uni/class.json" forKey:@"json_package"];
    }
    
    if ([self get:@"system_discussion"] == nil) {
        [self set:@"http://galic-design.com/tuwien/" forKey:@"system_discussion"];
        
    }
    
    if ([self get:@"username"] == nil) {
        [self set:@"Anonymous" forKey:@"username"];
        
    }
    
}

@end

