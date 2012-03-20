//
//  NetworkTuWienProcedure.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/20/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "NetworkTuWienProcedure.h"

@implementation NetworkTuWienProcedure{
    
}

+ (NSMutableDictionary *)loginAndGetIcalTokensWith:(NSString *)string pass:(NSString *)pass{
   

    //XLog(@"name: %@ pass: %@",string,pass);
    NSURL *url = [NSURL URLWithString:@"https://iu.zid.tuwien.ac.at/AuthServ.portal"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:pass forKey:@"pw"];
    [request addPostValue:string forKey:@"name"];    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
          NSString *resp = [request responseString];
        if (![self isLoggedIn:resp]) {
            @throw [NSException exceptionWithName:@"Login exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"LOGIN_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];

        }
        //  XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);
        @throw [NSException exceptionWithName:@"Connection exception" reason:[error localizedDescription] userInfo:nil];
        return nil;
    }
    [NetworkHelper listCookies];
    //[request release];
    //XLog(@"retain conut %i", [request retainCount]);

    [self makeASIQueryWithUrlNoResp:@"https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=36&login=TU+Account+Login"];
    

    
    //tuwel
    if (![self makeASIQueryWithUrlNoResp:@"https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=36&login=TU+Account+Login"]) {
        @throw [NSException exceptionWithName:@"tuwel authserv login exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"UNKNOWN_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];
        return nil;
    };

    
    
    //tiss
    if(![self makeASIQueryWithUrlNoResp:@"https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=76"] || ![self makeASIQueryWithUrlNoResp:@"https://tiss.tuwien.ac.at/events/personSchedule.xhtml"]){
        @throw [NSException exceptionWithName:@"tiss login exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"UNKNOWN_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];
        return nil;
    }
    
    NSString *tuwel_resp =[self makeASIQueryWithUrl:@"https://tuwel.tuwien.ac.at/calendar/view.php?view=upcoming"];
    if (tuwel_resp == nil) {
        @throw [NSException exceptionWithName:@"tuwel_resp login exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"UNKNOWN_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];
       // XLog(@"JARAN ERROR na tuwelu pri kalendaru parsing");
        return  nil;
    }
    
    NSString *tiss_resp = [self makeASIQueryWithUrl:@"https://tiss.tuwien.ac.at/events/personSchedule.xhtml"];
    if (tiss_resp == nil) {
        @throw [NSException exceptionWithName:@"tiss_resp login exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"UNKNOWN_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];

       // XLog(@"JARAN ERROR na tissu pri kalendaru parsing ");
        return  nil;
    }
    
    
//    XLog(@"tiss link leng %i",[[self scanTissCalendar:tiss_resp] length]);
  //  XLog(@"Tuwel link leng %i",[[self scanTUWELCalendar:tuwel_resp] length ]);
    NSString *tuwel = [self scanTUWELCalendar:tuwel_resp];
    NSString *tiss = [self scanTissCalendar:tiss_resp];
    
    if (tiss==nil) {
        XLog(@"TISS link parsin error maybe there is no calendar generated, order tiss to genereate a new one");
        // maybe there is no calendar that is created
        // get creation link
        tiss_resp = [self makeASIQueryWithUrl:[self generateTissCal:tiss_resp]];
        //XLog(@"GOT Back while generating ----- %@",tiss_resp);
        
        tiss = [self scanTissCalendar:tiss_resp];

        if (tiss == nil) {
            @throw [NSException exceptionWithName:@"Parsin tiss exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"PARSING_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];
            return nil;
        }
       // XLog(@"LINK ----- %@",[self getCalCreationLink:tiss_resp]);
        // and execute try again
    }
    
    // [NetworkHelper listCookies];
    
    if (tuwel==nil) {
        //XLog(@"JARAN ERROR pri kalendaru parsing");
        return nil;
    }
    

              
    NSMutableDictionary * ret = [NSMutableDictionary dictionary];
    [ret setObject:tiss forKey:@"tiss"];
    [ret setObject:tuwel forKey:@"tuwel"];

//    XLog(@"tiss link %@",  [self scanTissCalendar:tiss_resp]);
//    XLog(@"Tuwel link %@",  [self scanTUWELCalendar:tuwel_resp]);
    return ret;
}


+(BOOL)isLoggedIn:(NSString *)response{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:response error:&error];    
    HTMLNode *bodyNode = [parser body];
    NSArray *form = [bodyNode findChildTags:@"form"];

    for (HTMLNode *formnode in form) {
        // not logged in , since form is there
        if ([[formnode getAttributeNamed:@"action"]isEqualToString:@"AuthServ.portal"]) {
            [parser release];
            return NO;
        }
    }
    
    [parser release];
    return YES;
    
}

+(NSString*)generateTissCal:(NSString *)response{
    NSString *string = [self getDataBetweenFromString:response leftString:@"</dl>" rightString:@"</form>" leftOffset:0];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:string error:&error];    
    HTMLNode *bodyNode = [parser body];
    NSArray *form = [bodyNode findChildTags:@"form"];
    NSURL *url;

    for (HTMLNode *formnode in form) {
        // if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
        //NSLog(@"action %@", [formnode getAttributeNamed:@"action"]); //Answer to first question
        //NSLog(@"enctype %@", [formnode getAttributeNamed:@"enctype"]); //Answer to first question
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://tiss.tuwien.ac.at%@",[formnode getAttributeNamed:@"action"]]];
        // }
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"input"];
    
    for (HTMLNode *inputNode in inputNodes) {
        // if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
        //NSLog(@"name %@", [inputNode getAttributeNamed:@"name"]); //Answer to first question
        //NSLog(@"%@",[inputNode getAttributeNamed:@"value"] ); //Answer to first question
        [request setPostValue:[inputNode getAttributeNamed:@"value"] forKey:[inputNode getAttributeNamed:@"name"]];
        // }
    }
    

    [request addRequestHeader:@"Host" value:@"tiss.tuwien.ac.at"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    [request addRequestHeader:@"Accept-Language" value:@"en-us,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept-Charset" value:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7"];
    [request addRequestHeader:@"Connection" value:@"keep-alive"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *resp = [request responseString];
        [parser release];
        return resp;
        //  XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);
        [parser release];
        @throw [NSException exceptionWithName:@"Connection exception while generating new ical token" reason:[[NSBundle mainBundle] localizedStringForKey:@"GENERATE_ICAL_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];
        return nil;
        
    }

    
}

+(NSString *)makeASIQueryWithUrl:(NSString *)url1{
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
        @throw [NSException exceptionWithName:@"Connection exception" reason:[error localizedDescription] userInfo:nil];
        XLog(@"ERROR %@", error);
        return nil;
        
    }
}

+(BOOL)makeASIQueryWithUrlNoResp:(NSString *)url1{
    NSURL *url = [NSURL URLWithString:url1];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.shouldUseRFC2616RedirectBehaviour = YES;
    //request.
    //[request addRequestHeader:@"Host" value:@"tiss.tuwien.ac.at"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    [request addRequestHeader:@"Accept-Language" value:@"en-us,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept-Charset" value:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7"];
    [request addRequestHeader:@"Connection" value:@"keep-alive"];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        //  XLog(@"LOGIN OK --------> %i %@", [request responseStatusCode],resp);
        return YES;
    }else{
        XLog(@"ERROR --------> %i ", [request responseStatusCode]);
        @throw [NSException exceptionWithName:@"Connection exception" reason:[error localizedDescription] userInfo:nil];
        XLog(@"ERROR %@", error);
        return NO;

    }
}


// returns the full url of calendar token
+(NSString *)scanTissCalendar:(NSString *)response{
    NSString *string = @"";
    string = [self getDataBetweenFromString:response leftString:@"https://tiss.tuwien.ac.at/events/ical.xhtml" rightString:@"<input type=" leftOffset:0];
   // XLog(@" tiss length false %@", response);
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    if([string length]<90){
        //XLog(@" tiss length false %i", [string length]);
                return nil;
    }else{
        //XLog(@" tiss length true %i", [string length]);
        return string;
    }
}

// returns the full url of calendar token
+(NSString *)scanTUWELCalendar:(NSString *)response{
    NSString *string = [self getDataBetweenFromString:response leftString:@"export_execute.php" rightString:@"\">" leftOffset:0];
    NSString *ret =  [NSString stringWithFormat:@"%@%@",@"https://tuwel.tuwien.ac.at/calendar/",string];
    ret = [ret stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    if([ret length]<150){
        //XLog(@" Tuwel length false %i", [ret length]);
        
        @throw [NSException exceptionWithName:@"Parsin tuwel exception" reason:[[NSBundle mainBundle] localizedStringForKey:@"PARSING_EXCEPTION" value:@"" table:@"InfoPlist"] userInfo:nil];

        return nil;
    }else{
        //XLog(@" Tuwel length true %i", [ret length]);
        return ret;
    }
}

+ (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos 
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


@end
