//
//  MyItemToolBar.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "MyItemToolBar.h"
#import "MyWebView.h"
#import "LeftViewController.h"
#import "AlertMusicPlayer.h"

@implementation MyItemToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addItemForBottomToolBar];
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


//给底部添加标签
- (void)addItemForBottomToolBar
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左侧" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    leftItem.tag = 1001;
    
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    backItem.tag = 1002;
    
    UIBarButtonItem * refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    refreshItem.tag = 1003;
    
    UIBarButtonItem * pauseItem = [[UIBarButtonItem alloc] initWithTitle:@"停止" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    pauseItem.tag = 1004;
    UIBarButtonItem * forwardItem = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    forwardItem.tag = 1005;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"右侧" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    rightItem.tag = 1006;
    
    UIBarButtonItem * bookmarkItem = [[UIBarButtonItem alloc] initWithTitle:@"书签" style:UIBarButtonItemStyleBordered target:self action:@selector(goItemAction:)];
    bookmarkItem.tag = 1007;
    
    UIBarButtonItem * anotherSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    anotherSpace.width = -9.0f;
    NSArray * itemArray = [[NSArray alloc] initWithObjects:anotherSpace,leftItem,anotherSpace,backItem,anotherSpace,refreshItem,anotherSpace,pauseItem,anotherSpace,forwardItem,anotherSpace,bookmarkItem,anotherSpace,rightItem,anotherSpace, nil];
    [self setItems:itemArray animated:YES];
    
    [itemArray release];
    [leftItem release];
    [backItem release];
    [refreshItem release];
    [pauseItem release];
    [forwardItem release];
    [rightItem release];
    [anotherSpace release];
    
}

//响应底部工具栏上标签方法
- (void)goItemAction:(UIBarButtonItem *)sender
{
    AlertMusicPlayer * alertMP = [AlertMusicPlayer defaultAlertMusicPlayer];
    [alertMP automaticalJudgingPlay];
    if (sender.tag == 1001) { //左侧
        
        [self.ownDelegate pushLeftViewController];
        
    } else if (sender.tag == 1002){ //后退
        
        [_webView goBack];
        
    } else if (sender.tag == 1003){//刷新
        
        [_webView reload];
        
    } else if (sender.tag == 1004){//停止
        
        [_webView stopLoading];
        [_webView closeIndicatorView];
        
    } else if (sender.tag == 1005){//前进
        
        [_webView goForward];
        
    } else if (sender.tag == 1007) {
        
        [self.ownDelegate recordBookmark];
        
    } else {  //右侧
        
        [self.ownDelegate pushRightViewController];
        
    }
}

@end
