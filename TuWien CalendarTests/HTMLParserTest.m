//
//  HTMLParserTest.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/15/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "HTMLParserTest.h"

#import <UIKit/UIKit.h>
//#import "application_headers" as required

@implementation HTMLParserTest


- (void)setUp
{
    [super setUp];


    // Set-up code here.
    XLog();

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testExtractCalLinksFromTuwel{
    return;
    NSURL *url = [NSURL URLWithString:@"https://iu.zid.tuwien.ac.at/AuthServ.portal"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *resp = [request responseString];
        XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);

    }
    
    
    
    
    //tiss
    [self makeASIQueryWithUrlNoResp:@"https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=76"];
    [self makeASIQueryWithUrlNoResp:@"https://tiss.tuwien.ac.at/events/personSchedule.xhtml"];
    NSString *tiss_resp = [self makeASIQueryWithUrl:@"https://tiss.tuwien.ac.at/events/personSchedule.xhtml"];
    
    //tuwel
    [self makeASIQueryWithUrlNoResp:@"https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=36&login=TU+Account+Login"];
    NSString *tuwel_resp =[self makeASIQueryWithUrl:@"https://tuwel.tuwien.ac.at/calendar/view.php?view=upcoming"];

    [NetworkHelper listCookies];
    [ASIHTTPRequest setSessionCookies:nil];
    
    XLog(@"tiss link %@",  [self scanTissCalendar:tiss_resp]);
    XLog(@"Tuwel link %@",  [self scanTUWELCalendar:tuwel_resp]);

}

-(NSString *)makeASIQueryWithUrl:(NSString *)url1{
    NSURL *url = [NSURL URLWithString:url1];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.shouldUseRFC2616RedirectBehaviour = YES;
    [request addRequestHeader:@"Host" value:@"tiss.tuwien.ac.at"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    [request addRequestHeader:@"Accept-Language" value:@"en-us,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept-Charset" value:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7"];
    [request addRequestHeader:@"Connection" value:@"keep-alive"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *resp = [request responseString];
        return resp;
        //  XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);
        return NULL;

    }
}

-(void )makeASIQueryWithUrlNoResp:(NSString *)url1{
    NSURL *url = [NSURL URLWithString:url1];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.shouldUseRFC2616RedirectBehaviour = YES;
    [request addRequestHeader:@"Host" value:@"tiss.tuwien.ac.at"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    [request addRequestHeader:@"Accept-Language" value:@"en-us,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept-Charset" value:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7"];
    [request addRequestHeader:@"Connection" value:@"keep-alive"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        //  XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);
        
    }
}


// returns the full url of calendar token
-(NSString *)scanTissCalendar:(NSString *)response{
    NSString *string = [[[NSString alloc]init]autorelease];
    string = [self getDataBetweenFromString:response leftString:@"https://tiss.tuwien.ac.at/events/ical.xhtml" rightString:@"<input type=" leftOffset:0];
    return [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

// returns the full url of calendar token
-(NSString *)scanTUWELCalendar:(NSString *)response{
    NSString *string = [self getDataBetweenFromString:response leftString:@"export_execute.php" rightString:@"\">" leftOffset:0];
    NSString *ret =  [NSString stringWithFormat:@"%@%@",@"https://tuwel.tuwien.ac.at/calendar/",string];
    return  [ret stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];;
}

- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos 
{         
    NSInteger left, right;         
    NSString *foundData;
    NSScanner *scanner=[NSScanner scannerWithString:data];                  
    [scanner scanUpToString:leftData intoString: nil];         
    left = [scanner scanLocation];         
    [scanner setScanLocation:left + leftPos];         
    [scanner scanUpToString:rightData intoString: nil];         
    right = [scanner scanLocation] + 1;         
    left += leftPos;         
    foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];         return foundData; 
}



// All code under test is in the iOS Application


@end
