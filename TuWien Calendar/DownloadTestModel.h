#import <Three20/Three20.h>
#import "ASIFormDataRequest.h"
#import "SettingsHelper.h"
#import "Post.h"
#import "JSONHelper.h"


@interface DownloadTestModel : NSObject <TTModel,ASIHTTPRequestDelegate> {
    NSMutableArray* _delegates;
    NSMutableArray* _posts;
    NSString *_uid;
    ASIFormDataRequest *_request;
}

@property(nonatomic,retain) NSString* uid;
@property(nonatomic,assign) ASIFormDataRequest *request;
@property(nonatomic,assign) NSMutableArray* posts;

- (id)initWithUid:(NSString*)uid;
- (void)setReq;
@end
