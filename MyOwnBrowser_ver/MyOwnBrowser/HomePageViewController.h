//
//  HomePageViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftViewController.h"
#import "DoLeftOrRightProtocol.h"

@class MySearchToolBar;
@class MyItemToolBar;
@class MyWebView;

@interface HomePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIWebViewDelegate,DoLeftOrRightProtocol,UIAlertViewDelegate>

@property(nonatomic,retain)MyWebView * aWebView; //显示网页控件

@property(nonatomic,retain)MySearchToolBar * topSearchToolBar; //顶部工具栏
@property(nonatomic,retain)MyItemToolBar * bottomToolBar; //底部工具栏

@property(nonatomic,retain)NSMutableArray * resultURLDatas; //搜索url结果数组
@property(nonatomic,retain)NSMutableArray * resultKeywordDatas; //搜索关键字结果数组
@property(nonatomic,retain)NSMutableArray * resultDatas; //存放搜索结果数据

@property(nonatomic,assign)int windowNumber;//窗口编号
@property(nonatomic,retain)NSString * defaultURLString;


@end
