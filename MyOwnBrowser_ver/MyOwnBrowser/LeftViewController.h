//
//  LeftViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationIconProtocol.h"
#import "IconNavigation.h"

@class MyWebView;
@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavigationIconProtocol>
{
    int _iconRowWidth;
    int _iconColumnHeight;
}
@property(nonatomic,retain)UITableView * aTableView; //表属性
@property(nonatomic,retain)UIScrollView * aScrollView; //滚动视图，显示导航栏

@property(nonatomic,retain)NSMutableArray * iconDatas; //导航图标数据源
@property(nonatomic,retain)MyWebView * aWebView;
@property(nonatomic,assign)int iconRowWidth;
@property(nonatomic,assign)int iconColumnHeight;



- (void)adjustScrollViewContentSize;
@end
