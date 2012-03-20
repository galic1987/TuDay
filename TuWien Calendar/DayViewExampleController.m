/*
 * Copyright (c) 2010 Matias Muhonen <mmu@iki.fi>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DayViewExampleController.h"
#import "MAEvent.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface DayViewExampleController(PrivateMethods)
@property (readonly) MAEvent *event;
@end

@implementation DayViewExampleController
@synthesize detailViewController=_detailViewController,events=_events;
-(id)init{
    if (self = [super init]) {
        self.title = [LangHelper get:@"CALENDAR"];
		self.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        CGRect rect = self.view.bounds;
        rect.size.height = rect.size.height-49;
        MADayView *ma = [[MADayView alloc]initWithFrame:rect];
        ma.delegate = self;
        ma.dataSource = self;
        [self.view addSubview:ma];
        [self viewWillAppear:YES];
        [ma release];
}
    
    return self;
}


/* Implementation for the MADayViewDataSource protocol */


- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
    if ([ResourcesHelper getClassrooms] == nil) {
       // self.classrooms = [ResourcesHelper getClassrooms];
    }
    
    NSString * cal_name = [SettingsHelper get:@"cal_name"];
    //XLog(@"%@", cal_name);
    if (cal_name==nil) {
        cal_name = @"Tu Wien";
        [SettingsHelper set:cal_name forKey:@"cal_name"];
    }
    [_events release];
    _events = [[NSMutableArray alloc]init];
    NSArray *events_in = nil;
    
    @try {
        //XLog(@"calendar name: %@  time: %@", cal_name,startDate);
        events_in = [CalendarHelper getEKEventsforSingleDay:cal_name forDate:startDate]; 
        //[startDate release];
       // XLog(@"events_in %@",events_in);
        if (events_in==nil) {
            return nil;
        }
        for (EKEvent *ev in events_in) {
            MAEvent *m = [[MAEvent alloc]init];
            m.backgroundColor =  [UIColor blueColor];
            m.textColor = [UIColor whiteColor];
            m.allDay = ev.allDay;
            m.title = ev.title;
            m.start = ev.startDate;
            m.end   = ev.endDate;
            m.description = ev.notes;
            m.location = ev.location;
            m.calevent = ev;
            [_events addObject:m];
            [m release]; 
          //  XLog(@"%@", ev.UUID);

            
        }
        //[events_in release];

        
    }
    @catch (NSException *exception) {
        // [events_in release];
        [_events release];
        XLog(@"exception catch %@", exception);
        return nil;
    }
    
    
       XLog(@"retain count  %i %i", [events_in retainCount], [_events retainCount]);
    
    
    return (NSArray*) _events;   

}


/* Implementation for the MADayViewDelegate protocol */

- (void)dayView:(MADayView *)dayView eventTapped:(MAEvent *)event {
        XLog(@"%@", event.calevent);

//    EKEvent * ek = [CalendarHelper getSingleEk:event.calevent];
//    XLog(@"%@", ek);
    self.detailViewController = [[[LecturesDetailViewController alloc]initWithLocation:event.location]autorelease];
	
    _detailViewController.event = event.calevent;

    // ovdje dolazi download sa websitea

	//_detailViewController.allowsEditing = NO;
    [self.navigationController pushViewController:_detailViewController animated:YES];
    self.navigationController.navigationBarHidden = NO;

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated{
   // [self.detailViewController release];
    self.navigationController.navigationBarHidden = YES;

    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_events release];
    //[_classrooms release];
    [_detailViewController release];
    [super dealloc];
}


@end
