//
//  MyNavigationViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-3.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigationButton;
@interface MyNavigationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    bool closedHistoryResults[20];
}
@property(nonatomic,retain)UISegmentedControl * segCtrl; //底部分段控制器
@property(nonatomic,retain)UITableView * aTableView; //表视图
@property(nonatomic,retain)UITableView * aBookmarkTableView; //书签表

@property(nonatomic,retain)NSMutableArray * bookmarkDatas; //书签记录
@property(nonatomic,retain)NSMutableArray * resultDatas; //显示历史数据记录

@property(nonatomic,retain)NavigationButton * AddNavigation; //获取左侧的添加按钮

@property(nonatomic,retain)NSMutableData * receiveData;
@property(nonatomic,retain)NSIndexPath * currentIndexPath; //保存当前行列

@property(nonatomic,retain)NSMutableString * iconName; //保存下载网络请求图片的名字

@property(nonatomic,retain)NSIndexPath * historyIndexPath;
@property(nonatomic,retain)NSIndexPath * bookmarkIndexPath;

@end
