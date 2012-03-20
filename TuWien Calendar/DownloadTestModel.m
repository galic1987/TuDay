#import "DownloadTestModel.h"
#import <Three20/Three20.h>

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface DownloadTestModel ()
- (void) setReq;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DownloadTestModel
static BOOL loading;
@synthesize posts = _posts, uid=_uid, request=_request;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public
- (id)initWithUid:(NSString*)uid{
    if (self = [self init]) {
        self.uid = uid;
        [self setReq];
        _delegates = nil;
        _posts = nil;
}
    return self;
}


- (void)setReq{
    loading = YES;
    NSURL *url1 = [NSURL URLWithString:[SettingsHelper get:@"system_discussion"]];
    _request = [ASIFormDataRequest requestWithURL:url1];
    [_request addPostValue:_uid forKey:@"e_uid"];
    _request.delegate = self;
    [_request startAsynchronous];

}
///////////////////////////////////////////////////////////////////////////////////////////////////
// private

//- (void)fakeSearch:(NSString*)text {
//    self.names = [NSMutableArray array];
//    
//    if (text.length) {
//        text = [text lowercaseString];
//        for (NSString* name in _allNames) {
//            if ([[name lowercaseString] rangeOfString:text].location == 0) {
//                [_posts addObject:name];
//            }
//        }
//    }
//    
//    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
//}
//
//- (void)fakeSearchReady:(NSTimer*)timer {
//    _fakeSearchTimer = nil;
//    
//    NSString* text = timer.userInfo;
//    [self fakeSearch:text];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject



- (void)dealloc {
    [_uid release];
    TT_RELEASE_SAFELY(_delegates);
    TT_RELEASE_SAFELY(_posts);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (NSMutableArray*)delegates {
    if (!_delegates) {
        _delegates = TTCreateNonRetainingArray();
    }
    return _delegates;
}

- (BOOL)isLoadingMore {
    return loading;
}

- (BOOL)isOutdated {
    return NO;
}

- (BOOL)isLoaded {
    return !loading;
}

- (BOOL)isLoading {
    return loading;
}

- (BOOL)isEmpty {
    return !_posts.count;
}



- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {  
    XLog();
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
    [self setReq];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    XLog();
    loading = NO;

    // Use when fetching text data
    NSString *responseString = [request responseString];
   // [_posts release];
    //TT_RELEASE_SAFELY(_posts);
    _posts = [JSONHelper getPostsArray:responseString];
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    loading = NO;
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];

    NSError *error = [request error];
}


- (void)invalidate:(BOOL)erase {
    XLog();
}

- (void)cancel {

    [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)loadNames {
    TT_RELEASE_SAFELY(_posts);
   // _posts = [_allNames mutableCopy];
}

//- (void)search:(NSString*)text {
//    [self cancel];
//    
//    TT_RELEASE_SAFELY(_posts);
//    if (text.length) {
//        if (_fakeSearchDuration) {
//            TT_INVALIDATE_TIMER(_fakeSearchTimer);
//            _fakeSearchTimer = [NSTimer scheduledTimerWithTimeInterval:_fakeSearchDuration target:self
//                                                              selector:@selector(fakeSearchReady:) userInfo:text repeats:NO];
//            [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
//        } else {
//            [self fakeSearch:text];
//            [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
//        }
//    } else {
//        [_delegates perform:@selector(modelDidChange:) withObject:self];
//    }
//}

@end
