//
//  NavigationButton.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-30.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "NavigationButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation NavigationButton

- (void)dealloc
{
    [imgView release];
    [_titleLabel release];
    [_img release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 10.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowOpacity = 1;
        self.autoresizesSubviews = YES;
        
        
        [self addTarget:self action:@selector(goClickDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(goClickEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 , 50, 60, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.lineBreakMode = NSLineBreakByClipping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setImg:(UIImage *)img
{
    if (_img != img) {
        [_img release];
        _img = [img retain];
        imgView = [[UIImageView alloc] initWithImage:_img];
        imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
        CGSize imgSize = imgView.frame.size;
        CGFloat scaleWith = 46.0/imgSize.width;
        CGFloat scaleHeight = 46.0/imgSize.height;
        CGFloat scaleMin = MIN(scaleWith, scaleHeight);
        imgView.transform = CGAffineTransformMakeScale(scaleMin, scaleMin);
        imgView.center = CGPointMake(35, 27);
        [self addSubview:imgView];
        
        [self addSubview:_titleLabel];
    }
}


- (void)goClickDown:(UIControl *)sender
{
    [self.iconDelegate whenBeginClickButtonResponse:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectInset(self.frame, 8, 8);
    [UIView commitAnimations];
    
}

- (void)goClickEnd:(UIControl *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectInset(self.frame, -10, -10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectInset(self.frame, 2, 2);
        } completion:^(BOOL finished) {
            [self.iconDelegate whenEndClickButtonResponse:self];
        }];
    }];  
}

@end
