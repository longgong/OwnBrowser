//
//  RightViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loadWebPageProtocol.h"

@interface RightViewController : UIViewController<loadWebPageProtocol>

@property(nonatomic,retain)UIScrollView * aScrollView;
@property(nonatomic,assign)int currentWindowNumber; //当前窗口编号

@property(nonatomic,retain)NSMutableArray * allPages; //存储从数据库中读出的所有页面记录
@property(nonatomic,retain)NSMutableArray * allImageViews; //存储与数据库页面记录对应的图片视图

@end
