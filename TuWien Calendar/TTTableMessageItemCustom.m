//
//  TTTableMessageItemCellModified.m
//  TuWien Calendar
//
//  Created by Ivo Galic on 11/27/11.
//  Copyright (c) 2011 Galic Design. All rights reserved.
//

#import "TTTableMessageItemCustom.h"
#import "Three20UI/TTTableMessageItemCell.h"

// UI
#import "Three20UI/TTImageView.h"
#import "Three20UI/TTTableMessageItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/NSDateAdditions.h"

static NSInteger  kMessageTextLineCount       = 1;
static const CGFloat    kDefaultMessageImageWidth   = 34.0f;
static const CGFloat    kDefaultMessageImageHeight  = 34.0f;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableMessageItemCustom

@synthesize linez;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {
        self.textLabel.font = TTSTYLEVAR(font);
        self.textLabel.textColor = TTSTYLEVAR(textColor);
        self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.textLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.contentMode = UIViewContentModeLeft;
        
        self.detailTextLabel.font = TTSTYLEVAR(font);
        self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.detailTextLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.contentMode = UIViewContentModeTop;
        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        
        
//        CGFloat maxWidth = 300;  
//        CGSize textSize = [self.detailTextLabel.text sizeWithFont:TTSTYLEVAR(font)  
//                                                constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
//                                                    lineBreakMode:UILineBreakModeTailTruncation];  
//        linez  = (textSize.height) / 18;
        
        
        self.detailTextLabel.numberOfLines = linez;
        self.detailTextLabel.contentMode = UIViewContentModeLeft;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_timestampLabel);
    TT_RELEASE_SAFELY(_imageView2);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    CGFloat maxWidth = tableView.width - 20;  
    TTTableMessageItem* field = object;  
    
    
    CGSize textSize = [field.text sizeWithFont:TTSTYLEVAR(font)  
                             constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
                                 lineBreakMode:UILineBreakModeTailTruncation];  
    
//    CGSize subtextSize = [field.subtext sizeWithFont:TTSTYLEVAR(font)  
//                                   constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];  
//    CGSize featureURLSize = [field.featureURL sizeWithFont:[UIFont systemFontOfSize:12]  
//                                         constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];  
    
    //return 20 + textSize.height + subtextSize.height + featureURLSize.height;
   // XLog(@"sizee %f", textSize.height);
    //kMessageTextLineCount = (textSize.height) / 18;
    //XLog(@"linez %i", kMessageTextLineCount);

    return textSize.height + 40 ;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    [_imageView2 unsetImage];
    _titleLabel.text = nil;
    _timestampLabel.text = nil;
    self.captionLabel.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = 300;  
    CGSize textSize = [self.detailTextLabel.text sizeWithFont:TTSTYLEVAR(font)  
                                                     constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)  
                                                         lineBreakMode:UILineBreakModeTailTruncation];  
    linez  = (textSize.height) / 18;

    
    
    CGFloat left = 0.0f;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
        
    } else {
        left = kTableCellMargin;
    }
    
    CGFloat width = self.contentView.width - left;
    CGFloat top = kTableCellSmallMargin;
    
    if (_titleLabel.text.length) {
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
        top += _titleLabel.height;
        
    } else {
        _titleLabel.frame = CGRectZero;
    }
    
    if (self.captionLabel.text.length) {
        self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.ttLineHeight);
        top += self.captionLabel.height;
        
    } else {
        self.captionLabel.frame = CGRectZero;
    }
    
    if (self.detailTextLabel.text.length) {
        //XLog(@"ttLineHeight %f linecount %i", self.detailTextLabel.font.ttLineHeight,linez);
        CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * linez;
        //XLog(@"left %f top %f width %f textHeight %f", left,top,width,textHeight);
        self.detailTextLabel.frame = CGRectMake(left, top, width, textHeight);
        
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }
    
    if (_timestampLabel.text.length) {
        _timestampLabel.alpha = !self.showingDeleteConfirmation;
        [_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
        _timestampLabel.top = _titleLabel.top;
        _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
        
    } else {
        _timestampLabel.frame = CGRectZero;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        _imageView2.backgroundColor = self.backgroundColor;
        _titleLabel.backgroundColor = self.backgroundColor;
        _timestampLabel.backgroundColor = self.backgroundColor;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        
        TTTableMessageItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.caption.length) {
            self.captionLabel.text = item.caption;
        }
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
        if (item.timestamp) {
            self.timestampLabel.text = [item.timestamp formatShortTime];
        }
        if (item.imageURL) {
            self.imageView2.urlPath = item.imageURL;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = TTSTYLEVAR(tableFont);
        _titleLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)captionLabel {
    return self.textLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
        _timestampLabel.textColor = TTSTYLEVAR(timestampTextColor);
        _timestampLabel.highlightedTextColor = [UIColor whiteColor];
        _timestampLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_timestampLabel];
    }
    return _timestampLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[TTImageView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //    _imageView2.style = TTSTYLE(threadActorIcon);
        [self.contentView addSubview:_imageView2];
    }
    return _imageView2;
}

//+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
//   // XLog();
//    return 140;
//
//}

//-(void) layoutSubviews {
//    [super layoutSubviews];
// //   self.imageView2.frame =CGRectMake(10, 10, 90, 90);
//}


@end
