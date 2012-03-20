//
//  TTTableMessageItemCellModified.h
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/27/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "Three20UI/TTTableLinkedItemCell.h"

@class TTImageView;

@interface TTTableMessageItemCustom : TTTableLinkedItemCell {
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTImageView*  _imageView2;
    NSUInteger _linez;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly)         UILabel*      captionLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;
@property (nonatomic, readonly, retain) TTImageView*  imageView2;
@property (nonatomic) NSUInteger linez;


@end
