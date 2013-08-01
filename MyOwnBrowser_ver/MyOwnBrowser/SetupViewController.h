//
//  SetupViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-6.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView * aTableView;
@property(nonatomic,retain)NSMutableArray * setupDatas;

@property(nonatomic,assign) BOOL accessingSwicthFlag; //浏览历史选择开关刚进入时的状态，
@property(nonatomic,assign) BOOL accessingMusicSwicthFlag;//声音开关刚进入时的状态)
@end
