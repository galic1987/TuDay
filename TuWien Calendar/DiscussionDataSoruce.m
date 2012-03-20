//
//  DiscussionDataSoruce.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "DiscussionDataSoruce.h"
@implementation DiscussionDataSoruce
@synthesize uid = _uid,request=_request,ev=_ev;
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithUid:(NSString*)uid andEvent:(EKEvent *)event{
    if(self =  [super init]){
        self.uid = uid; 
        self.request = [[DownloadTestModel alloc]initWithUid:uid];
        self.ev = event;
   //     XLog("Starting");
        self.model = _request;
        
    }
    return self;
}


- (void)dealloc {
    [_ev release];
    TT_RELEASE_SAFELY(_request);
    [_uid release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

-(void)post{
    XLog();
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
    //XLog(@"%@", _addressBook.)
    XLog("Ending");

    
    self.items = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    //[_sections addObject:@"a"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
//    [_request.posts sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [sortDescriptor release];
   
    NSMutableDictionary* groups = [NSMutableDictionary dictionary];
    for (Post* p in _request.posts) {
        NSString *letter = [formatter stringFromDate:p.date];
        NSMutableArray* section = [groups objectForKey:letter];
        if (!section) {
            section = [NSMutableArray array];
            [groups setObject:section forKey:letter];
        }
        
        TTTableMessageItem* item =[TTTableMessageItem itemWithTitle:p.username caption:nil text:p.text timestamp:p.date URL:nil];
      //  XLog(@"retain count item %i", [item retainCount]);
        // item.description ;
        [section addObject:item];
    }
    [formatter release];
    
    TTTextEditor* editor = [[TTTextEditor alloc] init];
    editor.font = TTSTYLEVAR(font);
    editor.backgroundColor = TTSTYLEVAR(backgroundColor);
    editor.autoresizesToText = YES;
    editor.minNumberOfLines = 3;
    editor.placeholder = [LangHelper get:@"TEXT_WRITE"];
    editor.delegate = self;
    editor.returnKeyType = UIReturnKeyGo;
    //XLog(@"retain count editor %i", [editor retainCount]);

    NSString *s = [NSString stringWithFormat:@"%@ %@",[LangHelper get:@"ADD_POST"],[_ev title]];
    [_sections addObject:s];
    [_items addObject:[NSArray arrayWithObject:editor]];
    //[editor release];
    //[groups.
    //NSArray* letters = [groups.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString* letter in groups.allKeys) {
        NSArray* items = [groups objectForKey:letter];
        [_sections addObject:letter ];
        [_items addObject:items];
    }

}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[TTTableMessageItem class]]) {
        return [TTTableMessageItemCustom class];
    } else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

- (void)textEditorDidEndEditing:(TTTextEditor*)textEditor{
    XLog(@"Text to be sent %@", [textEditor text] );
    

   // [textEditor resignFirstResponder]; 

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Do whatever you want for your done button
    [textField resignFirstResponder]; 
    XLog(@"Text to be sent %@", [textField text] );

    return YES;
}

-(BOOL)textEditorShouldReturn:(TTTextEditor *)textEditor{
    NSString * str = [textEditor text];
    dispatch_queue_t aQueue =  dispatch_queue_create("com.galic-design.getter", NULL);
    dispatch_async(aQueue,^{
        NSURL *url1 = [NSURL URLWithString:[SettingsHelper get:@"system_discussion"]];
        ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url1];
        [req addPostValue:_uid forKey:@"e_uid"];
        [req addPostValue:[_ev title] forKey:@"e_title"];
        [req addPostValue:[_ev location] forKey:@"e_location"];
        [req addPostValue:[_ev notes] forKey:@"e_content"];
        [req addPostValue:[_ev startDate] forKey:@"e_start"];
        [req addPostValue:[_ev endDate] forKey:@"e_end"];
        [req addPostValue:str forKey:@"p_content"];
        NSString *username = [SettingsHelper get:@"username"];
        [req addPostValue:username forKey:@"p_username"];
        [req addPostValue:@"add" forKey:@"action"];
        [req startSynchronous];
        //                NSString *resp = [req responseString];
        //                XLog(@"Just got response %@", resp );
        dispatch_async(dispatch_get_main_queue(), ^{
            [textEditor resignFirstResponder];
            [_request load:TTURLRequestCachePolicyDefault more:YES];
            //[str release];
        });
        //[str release];
        
    });
    dispatch_release(aQueue);
    return YES;
}

- (id<TTModel>)model {
    return _request;
}



@end
