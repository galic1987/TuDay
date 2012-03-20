
#import "TableDragRefreshController.h"

@implementation TableDragRefreshController
@synthesize uid=_uid, ev=_ev;
///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

-(id)initWithUid:(NSString *)uid1 andEvent:(EKEvent *)event{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.uid = uid1;
        self.ev = event;
//        [[TTNavigator navigator].URLMap from:@"tt://post"
//                            toViewController:self selector:@selector(post:)];
    }
    return self;
}

-(void)dealloc{
    [_ev release];    
    [_uid release];
    [super dealloc];
}

//- (UIViewController*)post:(NSDictionary*)query {
//    TTPostController* controller = [[[TTPostController alloc] initWithNavigatorURL:nil
//                                                                             query:
//                                     [NSDictionary dictionaryWithObjectsAndKeys:@"Default Text", @"text", nil]]
//                                    autorelease];
//    controller.originView = [query objectForKey:@"__target__"];
//    return controller;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {

  [super loadView];
}



- (void) createModel {
    self.variableHeightRows = YES;
  DiscussionDataSoruce *ds = [[DiscussionDataSoruce alloc] initWithUid:_uid andEvent:_ev];
  //ds.addressBook.fakeLoadingDuration = 1.0;
  self.dataSource = ds;
  [ds release];
}

- (id<TTTableViewDelegate>) createDelegate {
  
  TTTableViewDragRefreshDelegate *delegate = [[TTTableViewDragRefreshDelegate alloc] initWithController:self];

  return [delegate autorelease];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [ThemeHelper getNavbarColor];

    
}

@end

