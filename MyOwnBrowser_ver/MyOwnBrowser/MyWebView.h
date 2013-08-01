//
//  MyWebView.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySearchToolBar;
@class MyItemToolBar;
@interface MyWebView : UIWebView
{
    BOOL _isHiddenToolBar;
    BOOL _isShowToolBar; //网页拖动时是否显示
    UIImageView * _imgV;
}

@property(nonatomic,retain)NSString * searchURLString; //存储搜索网址
@property(nonatomic,retain)UIActivityIndicatorView * indicatorView; //活动指示器

@property(nonatomic,retain)MySearchToolBar * theTopSearchToolBar; //顶部工具栏
@property(nonatomic,retain)MyItemToolBar * theBottomToolBar; //底部工具栏

- (void)openIndicatorView;  //打开活动指示器
- (void)closeIndicatorView; //关闭活动指示器

- (void)loadUrlWebSite:(NSString *)theURL; //加载网页方法

- (void)writeURLStringToPlist:(NSMutableArray *)theArray;


@end
