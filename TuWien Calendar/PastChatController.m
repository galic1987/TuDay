//
//  PastChatController.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/9/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "PastChatController.h"

@implementation PastChatController


@synthesize eventsList;


#pragma mark -
#pragma mark Initilize

- (PastChatController *)init{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
        self.title = [LangHelper get:@"PASTDISCUSS"];
        self.tabBarItem.image = [UIImage imageNamed:@"speechmedia.png"];
	}
	return self;
}




#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [eventsList release];
	[super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    
	//self.eventsList = [self fetchEventsForToday];
	// Fetch today's event on selected calendar and put them into the eventsList array
	//[self.tableView reloadData];
	
}


- (void)viewDidUnload {
	self.eventsList = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [ThemeHelper getNavbarColor];

    XLog();
    if(self.eventsList != nil){
        self.eventsList = nil;
    }

    self.eventsList = [self fetchEventsForToday];
    [self.tableView reloadData];
    
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];	 
}


// Support all orientations except for Portrait Upside-down.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Table view data source

// Fetching events happening in the next 15 days with a predicate, limiting to the default calendar 
- (NSMutableArray *)fetchEventsForToday {
    
    NSMutableArray *ar = [CalendarHelper getEKEventsFromCalendarWithPrefix:[SettingsHelper get:@"cal_name"] startingDay:-7 endingDay:1];
    if (!ar || !ar.count){
        return nil;
    }
    [ar reverse];
	return ar;
}


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.tableView) return [[self.eventsList objectAtIndex:section] count];
	return 0;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section{
	if (aTableView == self.tableView) 
	{
        //XLog(@" %i %i" ,section, [[self.eventsList objectAtIndex:section] count] );
		if ([[self.eventsList objectAtIndex:section] count] == 0) return nil;
		EKEvent * event = [[self.eventsList objectAtIndex:section] objectAtIndex:0];
		NSDate * date = [event startDate];
		NSString * string = [CalendarHelper getFormatedDate:date formatter:@"EEEE dd/MM/yyyy"];
		return [NSString stringWithFormat:@"%@", string];
	}
	else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	// Add disclosure triangle to cell hh:mma
	UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = editableCellAccessoryType;
	
	// Get the event at the row selected and display it's title
	//cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
	EKEvent *e = [[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	
	NSDate * dateStart = [e startDate];
	NSDate * dateEnd = [e endDate];
	NSString * date1 = [CalendarHelper getFormatedDate:dateStart formatter:@"hh:mm"];
	NSString * date2 = [CalendarHelper getFormatedDate:dateEnd formatter:@"hh:mm"];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", date1, date2];
	cell.detailTextLabel.text = [e title];
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	// Upon selecting an event, create an EKEventViewController to display the event.
    
//	self.detailViewController = [[LecturesDetailViewController alloc] initWithClassrooms:self.classrooms location:[[[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] location]];	
//	
//	detailViewController.event = [[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    

    
   // XLog(@"Uid scannned starting discussion borad with UID: %@", string);
    EKEvent * now = [[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    TableDragRefreshController *tt = [[TableDragRefreshController alloc]initWithUid:[CalendarHelper getEventID:now] andEvent:now];
    
    [self.navigationController pushViewController:tt animated:YES];
    
    
    return;
	
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.eventsList count];
}




@end