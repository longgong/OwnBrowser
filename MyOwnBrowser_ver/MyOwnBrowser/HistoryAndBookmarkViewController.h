//
//  HistoryAndBookmarkViewController.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryAndBookmarkProtocol.h"

@class BottomBookMarkToolbar;
@interface HistoryAndBookmarkViewController : UIViewController<HistoryAndBookmarkProtocol,UITableViewDataSource,UITableViewDelegate>
{
    bool closedHistoryResults[4]; //展开或关闭历史记录，yes代表关闭,no代表展开
    
}

@property(nonatomic,retain)BottomBookMarkToolbar * downToolbar; //书签和历史页面底部工具栏
@property(nonatomic,retain)UITableView * aTableView; //显示历史或书签表

@property(nonatomic,retain)NSMutableArray * resultArray; //存放历史或者书签记录
@property(nonatomic,retain)NSMutableArray * historyResults;


@end
