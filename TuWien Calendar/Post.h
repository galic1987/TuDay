//
//  Post.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/28/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject{
NSString *_username;
NSString *_text;
NSDate *_date;
}
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSDate *date;

-(id)initWithUsername:(NSString*)username
                 text:(NSString *)text
                 date:(NSDate*)date;

@end
