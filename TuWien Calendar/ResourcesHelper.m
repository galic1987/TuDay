//
//  ResourcesHelper.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 12/7/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "ResourcesHelper.h"

@implementation ResourcesHelper
static NSMutableArray *classrooms;
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        XLog();

        initialized = YES;
        [self getData];

    }
}

+(NSMutableArray *)getClassrooms{
    if (classrooms==nil) {
        [self getData];
        return nil;
    }
    XLog(@"count array %i", [classrooms retainCount]);

    return classrooms;
}

+(void)getData{
    XLog();
   // @synchronized(self) {
        if (classrooms!=nil) {
            return;
        }
    //dispatch_queue_t aQueue =  dispatch_queue_create("galic-design.com.getter", NULL);
//        dispatch_async(dispatch_get_main_queue(), ^{
        if (classrooms==nil) {
        NSString *classrooms_url = [SettingsHelper get:@"json_package"];
            NSURL *url = [NSURL URLWithString:classrooms_url];
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

            [request setCompletionBlock:^{
                if (classrooms!=nil) {
                    return;
                }
                // Use when fetching text data
                NSError *error = [request error];
                if (!error) {
                    NSString *resp=[request responseString];
                    NSDictionary *dict = [resp JSONValue];
                    NSMutableArray *array = [NSMutableArray array ];   
                    
                    for (NSDictionary* d in dict){
                        // XLog("---->");
                        // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                        
                        NSString * address = [d objectForKey:@"address"];
                        NSString * location = [d objectForKey:@"location"];
                        NSString * name = [d objectForKey:@"name"];
                        NSString * pdf_link_wegweiser = [d objectForKey:@"pdf_link_wegweiser"];
                        NSString * type = [d objectForKey:@"type"];
                        
                        
                        
                        Classroom *c = [[Classroom alloc]initWithName:name address:address location:location type:type pdflink:pdf_link_wegweiser];
                        
                        XLog(@"Adress cnt%i", [address retainCount]);
                        
                        XLog("\nAddress:%@\nLocation:%@\nname:%@\npdf_link:%@\ntype:%@\n",address,location,name,pdf_link_wegweiser,type );
                        
                        [array addObject:c];
                        [c release];
                        
                        XLog(@"Adress cnt%i", [address retainCount]);
                        
                        // [pool drain];
                    }
                    //[dict release];
                    XLog(@"%i", [array retainCount]);
                    
                    classrooms =  array;
                    [classrooms retain];
                    
                }else{
                    XLog(@"ERROR %@", error);
                    classrooms = nil;
                    //STFail(@"problem while accessin json package");
                }
            }];
            [request setFailedBlock:^{
                XLog(@"ERROR %@", [request error]);
            }];
            [request startAsynchronous];
        }
//    });
   // dispatch_release(aQueue);
    
     //   }
}




@end
