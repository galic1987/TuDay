//
//  AppDelegate.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 10/29/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize appSettingsViewController;
static UIAlertView *alert;
static BOOL finished;
- (void)dealloc
{
    [_window release];
    [tabController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

   [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone]; 

    [SettingsHelper registerDefaultsFromSettingsBundle];
    
        
    appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
    appSettingsViewController.delegate = self;
	//calendar2.hasAddButton = YES;
	// create navigation view
    
    DayViewExampleController *dayviewCalendar = [[DayViewExampleController alloc]init];
    MensaViewController *mensaView = [[MensaViewController alloc]init];
    LecturesCalendarTableViewController *incomingView = [[LecturesCalendarTableViewController alloc]init];
    PastChatController *past = [[PastChatController alloc]init];
    
    UINavigationController *nav1 = [[[UINavigationController alloc] initWithRootViewController:incomingView] autorelease];

    UINavigationController *nav2 = [[[UINavigationController alloc] initWithRootViewController:dayviewCalendar] autorelease];
    
    UINavigationController *nav3 = [[[UINavigationController alloc] initWithRootViewController:past] autorelease];
    
    UINavigationController *nav4 = [[[UINavigationController alloc] initWithRootViewController:mensaView] autorelease];
    
    UINavigationController *nav5 = [[[UINavigationController alloc] initWithRootViewController:appSettingsViewController] autorelease];


    nav2.navigationBarHidden = YES;


	// create tab controller
	tabController = [[UITabBarController alloc] init];
	tabController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5,nil];
	
	// setup window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[_window addSubview:tabController.view];
    [_window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    //[self dismissModalViewControllerAnimated:YES];
	
	// your code here to reconfigure the app for changed settings
}

// optional delegate method for handling mail sending result
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"Icon.png"].size.height + 25;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderForKey:(NSString*)key {
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
		imageView.contentMode = UIViewContentModeCenter;
		return [imageView autorelease];
	}
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"customCell"]) {
		return 44*3;
	}
	return 0;
}



#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForKey:(NSString*)key {
  
    
	if ([key isEqualToString:@"login"]) {
            finished = NO; // denote that we are updating the CalendarStore
            alert = [[UIAlertView alloc] initWithTitle:[LangHelper get:@"CONN_AND_DOWNLOADING"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            
            [alert show];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
            [indicator startAnimating];
            [alert addSubview:indicator];
            [indicator release];
        
              
        dispatch_queue_t aQueue =  dispatch_queue_create("com.galic-design.getter", NULL);
        dispatch_async(aQueue,^{
            XLog("Updater thread started, display the loader");
            int tiss_events = 0;
            int tuwel_events = 0;
            @try {
                NSString *login = [SettingsHelper get:@"studentId"];
                NSString *password = [SettingsHelper get:@"password"];
                NSDictionary *dict = [NetworkTuWienProcedure loginAndGetIcalTokensWith:login pass:password];
                XLog(@"got folowing links %@", dict);
                XLog("saving into settings");
                dispatch_sync(dispatch_get_main_queue(), ^{
                    alert.title = [LangHelper get:@"CONN_LOGGED_PARSING_TISS"];
                });
                
                // do the stuf
                [SettingsHelper set:[dict objectForKey:@"tiss"] forKey:@"tiss_URL"];
                [SettingsHelper set:[dict objectForKey:@"tuwel"] forKey:@"tuwel_URL"];
                
                NSString * cal_name = @"";
                if ([SettingsHelper get:@"cal_name"]!=nil) {
                    cal_name = [SettingsHelper get:@"cal_name"];
                }else{
                    cal_name = @"Tu Wien";
                }
                
                
                XLog(@"Using calendar name: %@", cal_name);
                
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatDay = [[NSDateFormatter alloc] init];
                [dateFormatDay setDateFormat:@"dd-MM-YYYY"];
                NSString *formattedDateString = [dateFormatDay stringFromDate:date];

                [SettingsHelper set:formattedDateString forKey:@"last_update"];
                [dateFormatDay release];
                ScannerIcalParser *s = [[ScannerIcalParser alloc]init];
                s.main = self;
                [CalendarHelper deleteCalendar:cal_name commit:YES];
                [CalendarHelper createNewCalendar:cal_name commit:YES];
  

                
                [s updateCalwithName:cal_name withLink:[dict objectForKey:@"tiss"] calType:@"tiss"];
                tiss_events = s.added;
                [s release];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // [alert dismissWithClickedButtonIndex:0 animated:YES];
                    alert.title = [LangHelper get:@"CONN_LOGGED_PARSING_TUWEL"];
                    // [alert show];
                });
                ScannerIcalParser *s1 = [[ScannerIcalParser alloc]init];
                s1.main = self;
                [s1 updateCalwithName:cal_name withLink:[dict objectForKey:@"tuwel"] calType:@"tuwel"];
                tuwel_events = s1.added;
                [s1 release];

                
                finished = YES;
                
                
                XLog("finishing updating 2");
                //     [alert dismissWithClickedButtonIndex:0 animated:YES];
                //      [alert release];


                
                
            } 
            @catch (id theException) {
 
                XLog(@"<<<Network Exception>>> %@", theException);
                dispatch_async(dispatch_get_main_queue(), ^{
                        // [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert release];
                        alert = [[UIAlertView alloc]initWithTitle:[LangHelper get:@"ERROR"] message:[theException reason]  delegate:NULL cancelButtonTitle:[LangHelper get:@"OK"] otherButtonTitles:nil, nil];
                        [alert show];                    
                });
            } 
            @finally {
                [ASIHTTPRequest setSessionCookies:nil];
                XLog(@"This always happens.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        // [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert release];
                        
                        alert = [[UIAlertView alloc]initWithTitle:[LangHelper get:@"FINISHED"] message:[NSString stringWithFormat:@"%@ %i \n %@ %i",[LangHelper get:@"TISS_IMP"],tiss_events,[LangHelper get:@"TUWEL_IMP"],tuwel_events] delegate:NULL cancelButtonTitle:[LangHelper get:@"OK"]otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    finished = YES; // denote that we are updating the CalendarStore

                });
            }
            
            




        });
        dispatch_release(aQueue);


        
	} else {
        finished = NO; // denote that we are updating the CalendarStore
        alert = [[UIAlertView alloc] initWithTitle:[LangHelper get:@"CONN_AND_DOWNLOADING"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        [alert show];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
        [indicator startAnimating];
        [alert addSubview:indicator];
        [indicator release];
        
        
        dispatch_queue_t aQueue =  dispatch_queue_create("com.galic-design.getter", NULL);
        dispatch_async(aQueue,^{
            XLog("Updater thread started, display the loader");
            int tiss_events = 0;
            int tuwel_events = 0;

            @try {                
                NSString * cal_name = @"";
                if ([SettingsHelper get:@"cal_name"]!=nil) {
                    cal_name = [SettingsHelper get:@"cal_name"];
                }else{
                    cal_name = @"Tu Wien";
                }
                
                
                
                XLog(@"Using calendar name: %@", cal_name);
                
                NSDate *date = [NSDate date];
                
                NSDateFormatter *dateFormatDay = [[NSDateFormatter alloc] init];
                [dateFormatDay setDateFormat:@"dd-MM-YYYY"];
                
                
                NSString *formattedDateString = [dateFormatDay stringFromDate:date];
                
                [SettingsHelper set:formattedDateString forKey:@"last_update"];
                
                [dateFormatDay release];
                
                if ([SettingsHelper get:@"tiss_URL"] == nil || [SettingsHelper get:@"tuwel_URL"]==nil) {
                    @throw [NSException exceptionWithName:@"Login exception" reason:[LangHelper get:@"LOGIN_EXCEPTION"] userInfo:nil];
                }
                
                ScannerIcalParser *s = [[ScannerIcalParser alloc]init];
                s.main = self; 
                [CalendarHelper deleteCalendar:cal_name commit:YES];
                [CalendarHelper createNewCalendar:cal_name commit:YES];
        
                dispatch_sync(dispatch_get_main_queue(), ^{
                    alert.title = [LangHelper get:@"CONN_LOGGED_PARSING_TISS"];
                });
                
                [s updateCalwithName:cal_name withLink:[SettingsHelper get:@"tiss_URL"] calType:@"tiss"];
                tiss_events = s.added;
                [s release];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    alert.title = [LangHelper get:@"CONN_LOGGED_PARSING_TUWEL"];
                });
                
                ScannerIcalParser *s1 = [[ScannerIcalParser alloc]init];
                s1.main = self;
                [s1 updateCalwithName:cal_name withLink:[SettingsHelper get:@"tuwel_URL"] calType:@"tuwel"];
                tuwel_events = s1.added;
                [s1 release];
                finished = YES;
                
                
                XLog("finishing updating 2");
                //     [alert dismissWithClickedButtonIndex:0 animated:YES];
                //      [alert release];
                
                
                
                
            } 
            @catch (id theException) {
                
                XLog(@"%@", theException);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // [alert dismissWithClickedButtonIndex:0 animated:YES];
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                    [alert release];
                    alert = [[UIAlertView alloc]initWithTitle:[LangHelper get:@"ERROR"] message:[theException reason]  delegate:NULL cancelButtonTitle:[LangHelper get:@"OK"] otherButtonTitles:nil, nil];
                    [alert show];                    
                });
            } 
            @finally {
                XLog(@"This always happens.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        // [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        [alert release];
                        alert = [[UIAlertView alloc]initWithTitle:[LangHelper get:@"FINISHED"] message:[NSString stringWithFormat:@"%@ %i \n %@ %i",[LangHelper get:@"TISS_IMP"],tiss_events,[LangHelper get:@"TUWEL_IMP"],tuwel_events] delegate:NULL cancelButtonTitle:[LangHelper get:@"OK"]otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    finished = YES; // denote that we are updating the CalendarStore
                    
                });
            }
            
            
            
            
            
            
        });
        dispatch_release(aQueue);	}
}

-(void)changeUpdatingProcess:(id)sender string:(NSString *)string{
    dispatch_sync(dispatch_get_main_queue(), ^{
        alert.title = string;
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [alert release];
}




@end
