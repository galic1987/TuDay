//
//  NetworkHelper.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/15/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper



+ (NSMutableArray*) getClassromsArray:(NSString *)url{

    NSURL *url1 = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url1];
    [request startSynchronous];
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
        
        return array;
    }else{
        XLog(@"ERROR %@", error);
        return nil;
        //STFail(@"problem while accessin json package");
    }
    
    
}



+ (BOOL)clearCookiesByUrl:(NSString *)url{
    NSHTTPCookieStorage * sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [sharedCookieStorage cookies];
    for (NSHTTPCookie * cookie in cookies){
        XLog(@"Cookie Domain: %@  Cookie name: %@ Cookie value: %@" , cookie.domain, cookie.name , cookie.value );
        if ([cookie.domain rangeOfString:url].location != NSNotFound){
            XLog(@"Delete cookie with Domain: %@ Name: %@ Value: %@" , cookie.domain, cookie.name , cookie.value );
            [sharedCookieStorage deleteCookie:cookie];
           // return true;
        }
    }
    return false;
}


+ (void)listCookies{
    NSHTTPCookieStorage * sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [sharedCookieStorage cookies];
    for (NSHTTPCookie * cookie in cookies){
//        if ([cookie.domain rangeOfString:url].location != NSNotFound){
        XLog(@"Cookie Domain: %@ Name: %@ Value: %@" , cookie.domain, cookie.name , cookie.value );
//            return true;
//        }
    }
//    return false;
}


+ (void)dropAllCookies{
    NSHTTPCookieStorage * sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [sharedCookieStorage cookies];
    for (NSHTTPCookie * cookie in cookies){
        XLog(@"Delete cookie with Domain: %@ Name: %@ Value: %@" , cookie.domain, cookie.name , cookie.value );
        [sharedCookieStorage deleteCookie:cookie];
    }
}


+ (NSString *) allCookiesByUrl:(NSString *)url{
    NSHTTPCookieStorage * sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [sharedCookieStorage cookies];
    NSString *requestHeader =@"";
    for (NSHTTPCookie * cookie in cookies){
        XLog(@"Compare cookie.domain %@ == %@ url", cookie.domain, url);
        if ([cookie.domain hasPrefix:url]){
            XLog(@"Cookie Domain: %@  Cookie name: %@ Cookie value: %@" , cookie.domain, cookie.name , cookie.value );
            requestHeader = [NSString stringWithFormat:@"%@ %@=%@;",requestHeader, cookie.name, cookie.value ]; 
        }
    }
    XLog(@"Add cookie with Domain: %@",  requestHeader );

    return requestHeader;
}


@end
