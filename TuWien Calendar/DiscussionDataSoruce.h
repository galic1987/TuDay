//
//  DiscussionDataSoruce.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Three20/Three20.h>
#import "TTTableMessageItemCustom.h"
#import "DownloadTestModel.h"
#import "Post.h"
#import <dispatch/dispatch.h>
#import "NSString+ReverseString.h"
#import "LangHelper.h"

@interface DiscussionDataSoruce : TTSectionedDataSource <TTTextEditorDelegate>{
DownloadTestModel *_request;
    EKEvent *_ev;
NSString *_uid;
}

//@property(nonatomic,readonly) MockAddressBook* addressBook;
@property(nonatomic,retain) DownloadTestModel *request;
@property(nonatomic,retain) NSString *uid;
@property(nonatomic,retain) EKEvent *ev;


- (id)initWithUid:(NSString*)uid andEvent:(EKEvent*)event;
- (NSArray *)reversedArray ;
@end
