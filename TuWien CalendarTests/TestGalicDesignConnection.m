//
//  TestGalicDesignConnection.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/20/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "TestGalicDesignConnection.h"
#import <libxml2/libxml/HTMLparser.h>
#import "HTMLParser.h"

@implementation TestGalicDesignConnection



-(void)testDiscussion{

    NSURL *url = [NSURL URLWithString:[SettingsHelper get:@"system_discussion"]];
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:@"sampleuid" forKey:@"e_uid"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *resp=[request responseString];
        XLog(@"%@", resp);
        NSDateFormatter *dateFormatStandard = [[NSDateFormatter alloc] init];
        [dateFormatStandard setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dict = [resp JSONValue];
        NSMutableArray *array = [[NSMutableArray alloc]init];   
        for (NSDictionary* d in dict){
            // XLog("---->");
            NSString * text1 = [d objectForKey:@"content"];
            NSString * username1 = [d objectForKey:@"username"];
            NSString * date1 = [d objectForKey:@"created"];
     
            
            NSString *text = [NSString stringWithUTF8String:[text1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *username = [NSString stringWithUTF8String:[username1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *date = [NSString stringWithUTF8String:[date1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSDate *date_real = [dateFormatStandard dateFromString:date];
            Post *c = [[Post alloc]initWithUsername:username text:text date:date_real];
            STAssertNotNil(c , @"there should be no null while parsing", nil);
            [array addObject:c];
            [c release];
            
             XLog("\nUsername:%@\nText:%@\nDate:%@\n",username,text,date_real );
        }
        [dateFormatStandard release];
        

    }else{
        XLog(@"ERROR %@", error);
        STFail(@"problem while accessin json package");
    }
    
}
// All code under test must be linked into the Unit Test bundle
- (void)testParsingAndSearch
{
    return;
    
    
    NSString *html = 
    @"<ul>"
    "<li><input type='image' name='input1' value='string1value' /></li>"
    "<li><input type='image' name='input2' value='string2value' /></li>"
    "</ul>"
    "<span class='spantext'><b>Hello World 1</b></span>"
    "<span class='spantext'><b>Hello World 2</b></span>";
    
    
    NSString *htmk =@"<form id='j_id1400297206_1_78088060' name='j_id1400297206_1_78088060' method='post' action='/events/personSchedule.xhtml"
    "?windowId=2f4' enctype='application/x-www-form-urlencoded'>"
    "<h2>Termine in externem Kalendar abonnieren"
    "</h2>"
    
    "<p>Um Ihre TISS Termine in einem externen Kalender anzuzeigen, erzgeugen Sie einen Token und binden Sie das iCal File mithilfe des angeführten Links in Ihren externen Kalender ein. Falls Sie glauben, dass jemand Kenntnis von Ihrem Token erlangt hat, können Sie jederzeit einen neuen generieren.</p><input id='j_id1400297206_1_78088060:j_id1400297206_1_7808819f' name='j_id1400297206_1_78088060:j_id1400297206_1_7808819f' type='submit' value='Erzeuge neuen Token' onclick='jsf.util.chain(document.getElementById('j_id1400297206_1_78088060:j_id1400297206_1_7808819f'), event,'jsf.ajax.request(\'j_id1400297206_1_78088060:j_id1400297206_1_7808819f\',event,{render:\'@form globalMessagesPanel\',\'javax.faces.behavior.event\':\'action\'})'); return false;' /><input type='hidden' name='j_id1400297206_1_78088060_SUBMIT' value='1' /><input type='hidden' name='javax.faces.ViewState' id='javax.faces.ViewState' value='rO0ABXVyABNbTGphdmEubGFuZy5PYmplY3Q7kM5YnxBzKWwCAAB4cAAAAAJ1cQB+AAAAAAACdAABMnB0ABUvcGVyc29uU2NoZWR1bGUueGh0bWw=' /></form>";
    
    
    NSError *error = nil;

HTMLParser *parser = [[HTMLParser alloc] initWithString:htmk error:&error];    
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *inputNodes = [bodyNode findChildTags:@"input"];
    
    for (HTMLNode *inputNode in inputNodes) {
       // if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
            NSLog(@"name %@", [inputNode getAttributeNamed:@"name"]); //Answer to first question
            NSLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question

       // }
    }
    
    NSArray *form = [bodyNode findChildTags:@"form"];

    for (HTMLNode *formnode in form) {
        // if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
        NSLog(@"action %@", [formnode getAttributeNamed:@"action"]); //Answer to first question
        NSLog(@"enctype %@", [formnode getAttributeNamed:@"enctype"]); //Answer to first question
        
        // }
    }
    
//    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
//    
//    for (HTMLNode *spanNode in spanNodes) {
//        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
//            NSLog(@"%@", [spanNode rawContents]); //Answer to second question
//        }
//    }
    
    [parser release];
    
    
    return;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString = [prefs stringForKey:@"json_package"];
    NSURL *url = [NSURL URLWithString:myString];


    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
   // NSError *error = [request error];
    if (!error) {
        NSString *resp=[request responseString];
        
        NSDictionary *dict = [resp JSONValue];
        NSMutableArray *array = [[NSMutableArray alloc]init];   
        for (NSDictionary* d in dict){
           // XLog("---->");
            NSString * address1 = [d objectForKey:@"address"];
            NSString * location1 = [d objectForKey:@"location"];
            NSString * name1 = [d objectForKey:@"name"];
            NSString * pdf_link_wegweiser1 = [d objectForKey:@"pdf_link_wegweiser"];
            NSString * type1 = [d objectForKey:@"type"];
            
            NSString *address = [NSString stringWithUTF8String:[address1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *location = [NSString stringWithUTF8String:[location1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *name = [NSString stringWithUTF8String:[name1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *pdf_link_wegweiser = [NSString stringWithUTF8String:[pdf_link_wegweiser1 cStringUsingEncoding:NSUTF8StringEncoding]];  
            NSString *type = [NSString stringWithUTF8String:[type1 cStringUsingEncoding:NSUTF8StringEncoding]];  


            Classroom *c = [[Classroom alloc]initWithName:name address:address location:location type:type pdflink:pdf_link_wegweiser];
            STAssertNotNil(c , @"there should be no null while parsing", nil);
            [array addObject:c];
            [c release];
           // XLog("\nAddress:%@\nLocation:%@\nname:%@\npdf_link:%@\ntype:%@\n",address,location,name,pdf_link_wegweiser,type );
        }
        
        
        Classroom *c =[CalendarHelper searchClassroomByName:array name:@"Informatikhörsaal"];
        STAssertNotNil(c , @"it should find Informatikhörsaal", nil);
        XLog(@"FOUND %@", [c name]);
        
        Classroom *c1 =[CalendarHelper searchClassroomByName:array name:@"agoidgjasodigjal"];
        STAssertNil(c1 , @"it should not find", nil);
      //  XLog(@"FOUND %@", [c name]);
        
       // XLog(@"DICT %@", dict);
        //XLog(@"OK --------> %i %@", [request responseStatusCode],resp);
    }else{
        XLog(@"ERROR %@", error);
        STFail(@"problem while accessin json package");
    }
    
    



}

@end
