    //
//  MensaViewController.m
//  TUGuide
//
//  Created by Martin Langeder on 08.01.11.
//  Copyright 2011 7359. All rights reserved.
//

#import "MensaViewController.h"


@implementation MensaViewController

@synthesize mensaView;

- (id)init
{
	//Initialization of the ViewController and adding TabbarItems and Image
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = @"Food";
		UIImage* anImage = [UIImage imageNamed:@"48-fork-and-knife.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:[LangHelper get:@"FOOD"] image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
		
//		mensas = [[NSMutableArray alloc] initWithArray:m];
//		restaurants = [[NSMutableArray alloc] initWithArray:r];
	}
	
	return self;
	
}

//-(IBAction)segmentAction:(UISegmentedControl *)segmentPick
//{
//	NSLog(@"segment called %d", segmentPick.selectedSegmentIndex);
//	switch (segmentPick.selectedSegmentIndex) {
//		case 0:
//			//Do nothing because this is the right View and does not need to be changed
//			break;
//		case 1:
//			//Push the RestaurantViewController onto the NavigationStack. The Back Button will be hidden in -loadView
//			[self.navigationController pushViewController:[[RestaurantViewController alloc] initWithRestaurants:restaurants] animated:NO];
//			break;
//		default:
//			break;
//	}
//}

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
- (void)loadView {
	XLog();
	//applying the View to the ViewController
	mensaView = [[MensaView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
	//adding the ButtonActions
	[mensaView.mensaBlue addTarget:self action:@selector(mensaBlueAction:) forControlEvents:UIControlEventTouchUpInside];
	[mensaView.mensaRed addTarget:self action:@selector(mensaRedAction:) forControlEvents:UIControlEventTouchUpInside];
	[mensaView.mensaGreen addTarget:self action:@selector(mensaGreenAction:) forControlEvents:UIControlEventTouchUpInside];
	[mensaView.mensaOrange addTarget:self action:@selector(mensaOrangeAction:) forControlEvents:UIControlEventTouchUpInside];
	
	self.view = mensaView; 
	[mensaView release]; 
}

- (void)mensaBlueAction:(id)sender{
    [self gotoMensa:@"http://menu.mensen.at/index/index/locid/9"];
}
- (void)mensaRedAction:(id)sender{
    [self gotoMensa:@"http://menu.mensen.at/index/index/locid/52"];

}
- (void)mensaGreenAction:(id)sender{
    [self gotoMensa:@"http://menu.mensen.at/index/index/locid/12"];

}
- (void)mensaOrangeAction:(id)sender{
    //
    [self gotoMensa:@"http://menu.mensen.at/index/index/locid/13"];
}


- (void)gotoMensa:(NSString*)url{
    UIWebView *locationPdf = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 370.0)];
	[locationPdf setScalesPageToFit:YES];
    
	NSURL *targetURL;
    targetURL = [NSURL URLWithString:url];
    
	//NSLog(@"%@",c.pdf_link_cms);
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[locationPdf loadRequest:request];
    
    UIViewController *ui = [[[UIViewController alloc]init]autorelease];
    ui.view = locationPdf;
    [locationPdf release];
    
    [self.navigationController pushViewController:ui animated:YES];
}

	



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//Change color of the navigationBar
	self.navigationController.navigationBar.tintColor = [ThemeHelper getNavbarColor];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewDidAppear:(BOOL)animated{
	//segmentedController.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
