//
//  LecturesDetailViewController.m
//  TUGuide
//
//  Created by Ivo Galic
//  Copyright Galic Design All rights reserved.
//

#import "LecturesDetailViewController.h"


@implementation LecturesDetailViewController
@synthesize classroom;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//	detailView = [[LecturesDetailView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//	self.view = detailView;
//	
//	self.view.userInteractionEnabled = YES;
//}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



- (id)initWithLocation:(NSString*)location{
	self = [super initWithNibName:nil bundle:nil];
    if (self) {
		//self.classrooms = classes;
        if (location != nil) {
            self.classroom = [CalendarHelper getClassroom:location]; 
        }
        
        XLog(@"------------- %i -- %i", self.event.availability,[CalendarHelper getCalAvailabilitySupport:[SettingsHelper get:@"cal_name"]]);
        if ([CalendarHelper getCalAvailabilitySupport:[SettingsHelper get:@"cal_name"]] == EKCalendarEventAvailabilityNone) {
            classroom_row = 2;
            discuss_row = 3;
            nr_rows_in_section = 4;
            
        }else{
            classroom_row = 3;
            discuss_row = 4;
            nr_rows_in_section = 5; 
        }
        
        
        
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//if (tableView == self.tableView) return [[self.eventsList objectAtIndex:section] count];
	return nr_rows_in_section;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    XLog(@"classroom row %i ,discussion %i, number in section %i , current_index %i ", classroom_row,discuss_row,nr_rows_in_section,indexPath.row);
    
	if(indexPath.row < classroom_row) {
        return	[super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	
    
	static NSString *CellIdentifier = @"Cell";
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
	}
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	// Get the event at the row selected and display it's title
	//cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
	if(indexPath.row == classroom_row){
		if (classroom == nil) {
			cell.textLabel.text = [LangHelper get:@"NO_CLASSROOM"];
			cell.detailTextLabel.text = [LangHelper get:@"NO_CLASSROOM_TEXT"];
		}else {
			cell.textLabel.text = [LangHelper get:@"DISP_CLASSROOM"];
			cell.detailTextLabel.text = [classroom name];
		}		
	}
    
    if(indexPath.row == discuss_row){
        cell.textLabel.text = [LangHelper get:@"DISSCUSS"];
        cell.detailTextLabel.text = [LangHelper get:@"DISSCUSS_TEXT"];
		
	}
    
	
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	XLog(" %i ", indexPath.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    if (classroom != nil && indexPath.row == classroom_row) {	
        XLog(@"%@", indexPath);
        UIWebView *locationPdf = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 370.0)];
        [locationPdf setScalesPageToFit:YES];
        
        NSURL *targetURL;
        targetURL = [NSURL URLWithString:self.classroom.pdf_link_cms];
        
        //NSLog(@"%@",c.pdf_link_cms);
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [locationPdf loadRequest:request];
        
        UIViewController *ui = [[[UIViewController alloc]init]autorelease];
        ui.view = locationPdf;
        [locationPdf release];
        
        [self.navigationController pushViewController:ui animated:YES];
        return;
    }
    
    if(indexPath.row == discuss_row){

        
        //XLog(@"Uid scannned starting discussion borad with UID: %@", string);
        
        
        EKEvent * now = self.event;        
        TableDragRefreshController *tt = [[TableDragRefreshController alloc]initWithUid:[CalendarHelper getEventID:now] andEvent:now];

        
        [self.navigationController pushViewController:tt animated:YES];
        
        
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}




- (void)viewDidLoad{
    
	//self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];	
	//self.allowsEditing = YES;
    
	self.title = [[self event]title];
    
    //	classroom = [LecturesCalendarHelper searchClassroomByName:self.classrooms name:[self.event location]];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated{
	//[delegate2 passTo:self command:@"goDeselect" message:@"back"];
	[super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = [ThemeHelper getNavbarColor];
	if (classroom!=nil) {
        [[super tableView] deselectRowAtIndexPath:[[super tableView] indexPathForSelectedRow] animated:YES];
	}
	//[tableView deselectRowAtIndexPath:super.tableView.indexPathForSelectedRow animated:YES];
	[super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [classroom release];
    [super dealloc];
}


@end
