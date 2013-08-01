//
//  PresentView.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-5.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "PresentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PresentView

- (void)dealloc
{
    [_titleLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 10.0f;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        if (!_titleLabel) { //默认label
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont systemFontOfSize:12];
        } 
        
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setTitleLabel:(UILabel *)newTitleLabel
{
    if (newTitleLabel != _titleLabel) {
        [_titleLabel release];
        _titleLabel = [newTitleLabel retain];
        _titleLabel.frame = CGRectMake(self.frame.size.width/2.0 -  _titleLabel.frame.size.width/2.0, self.frame.size.height/2.0 - _titleLabel.frame.size.height/2.0, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
