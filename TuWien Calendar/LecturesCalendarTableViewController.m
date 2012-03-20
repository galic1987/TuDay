//
//  LecturesCalendarTableViewController.m
//  TUGuide
//
//  Created by Ivo Galic on 1/13/11.
//  Copyright 2011 Galic Design. All rights reserved.
//

#import "LecturesCalendarTableViewController.h"

@implementation LecturesCalendarTableViewController

@synthesize eventsList,detailViewController;


#pragma mark -
#pragma mark Initilize

- (LecturesCalendarTableViewController *)init{
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		//self.classrooms = [ResourcesHelper getClassrooms];
        self.title = [LangHelper get:@"INCOMING"];
        self.tabBarItem.image = [UIImage imageNamed:@"arrowdown.png"];
	}
	return self;
}




#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [eventsList release];
    [detailViewController release];
	//[classrooms release];
	[super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {


	
	// Initialize an event store object with the init method. Initilize the array for events.
	//˚


	//[self.eventsList addObjectsFromArray:[self fetchEventsForToday]];
	// Fetch today's event on selected calendar and put them into the eventsList array
	
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

    
	//XLog("deselect");
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
	return [CalendarHelper getEKEventsFromCalendarWithPrefix:[SettingsHelper get:@"cal_name"] startingDay:0 endingDay:8];
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

	self.detailViewController = [[LecturesDetailViewController alloc] initWithLocation:[[[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] location]];	
	
	detailViewController.event = [[self.eventsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	//XLog(" %s ", [detailViewController.event location]);
	detailViewController.navigationController.navigationBar.tintColor = [UIColor blackColor];	
	// Allow event editing.
	//detailViewController.allowsEditing = YES;
    [[self navigationController]pushViewController:self.detailViewController animated:YES];
	
	//	Push detailViewController onto the navigation controller stack
	//	If the underlying event gets deleted, detailViewController will remove itself from
	//	the stack and clear its event property.
	

	//detailViewController.delegate = self;
	
//	[delegate2 passTo:self command:@"editEvent" message:@"editingEvent"];
	//[self.navigationController pushViewController:detailViewController animated:YES];
	
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	 return [self.eventsList count];
}




@end