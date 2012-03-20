//
//  TuWien_CalendarTests.h
//  TuWien CalendarTests
//
//  Created by Ivo Galic on 10/29/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Three20/Three20.h>
#import <EventKit/EventKit.h>
#import "CalendarHelper.h"
#import "TFHpple.h"
#import "NetworkHelper.h"


@interface TuWien_CalendarTests : SenTestCase{
    TTURLDataResponse *response;

}
@property (retain,nonatomic) TTURLDataResponse *response;

@end
