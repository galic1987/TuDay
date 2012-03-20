//
//  AppDelegate.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 10/29/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCCalendar.h"
#import "DayViewExampleController.h"
#import "IASKSpecifier.h"
#import "IASKAppSettingsViewController.h"
#import "MADayView.h"
#import "NetworkTuWienProcedure.h"
#import <dispatch/dispatch.h>
#import "ScannerIcalParser.h"
#import "SettingsHelper.h"
#import "LangHelper.h"
#import "MensaViewController.h"
#import "LecturesCalendarTableViewController.h"
#import "PastChatController.h"
#import "AlertProtocol.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IASKSettingsDelegate,UITabBarControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,AlertProtocol>{
    UITabBarController *tabController;
    IASKAppSettingsViewController *appSettingsViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

@end
