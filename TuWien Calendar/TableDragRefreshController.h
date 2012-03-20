#import <Three20/Three20.h>
#import "DiscussionDataSoruce.h"
#import "ThemeHelper.h"
@interface TableDragRefreshController : TTTableViewController{
    NSString *_uid;
    EKEvent *_ev;

}
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) EKEvent *ev;

-(id)initWithUid:(NSString *)uid andEvent:(EKEvent *)event;
@end
