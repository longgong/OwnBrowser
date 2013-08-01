//
//  ZoomImageView.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-5.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "ZoomImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZoomImageView

- (void)dealloc
{
    [_urlString release];
    [_windowName release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel * winLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 40, 20)];
        winLabel.text = self.windowName;
        winLabel.tag = 200;
        winLabel.font = [UIFont systemFontOfSize:14];
//        winLabel.textColor = [UIColor grayColor];
        winLabel.layer.cornerRadius = 20;
        winLabel.layer.borderWidth = 2;
        winLabel.layer.borderColor = [UIColor blackColor].CGColor;
        winLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:winLabel];
        [winLabel release];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTap:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
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

- (void)setWindowName:(NSString *)windowName
{
    [windowName retain];
    [_windowName release];
    _windowName = windowName;
    UILabel * winLabel = (UILabel *)[self viewWithTag:200];
    winLabel.text = _windowName;
}

- (void)goTap:(UITapGestureRecognizer *)sender
{
    //找代理去加载网页
    [self.forwardDelegate goBackToLoadNewPage:self];
    NSLog(@"ddd");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ZoomView urlString = %@, windowName = %@, windowNumber = %d",self.urlString,self.windowName,self.windowNumber];
}

@end
