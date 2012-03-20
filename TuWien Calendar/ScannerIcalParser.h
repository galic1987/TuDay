//
//  ScannerIcalParser.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 10/30/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import <EventKit/EventKit.h>
#import "CalendarHelper.h"
#import "AlertProtocol.h"
#import "LangHelper.h"

@interface ScannerIcalParser : NSObject{
    //TTURLDataResponse *response;
    int added;
    id <AlertProtocol> main;
}
//@property (assign,nonatomic) TTURLDataResponse *response;
@property (assign,nonatomic) int added;
@property (assign,nonatomic) id <AlertProtocol> main;


- (BOOL)updateCalwithName:(NSString*)calendar
                 withLink:(NSString *)link
                  calType:(NSString *)calType;

@end
