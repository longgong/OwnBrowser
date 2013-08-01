//
//  HistoryURLTableViewCell.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-28.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryURLTableViewCell : UITableViewCell

@property(nonatomic,retain)UILabel * titleLable;
@property(nonatomic,retain)UILabel * urlLable;
@property(nonatomic,retain)UIView * operateView; //操作视图
@property(nonatomic,retain)UILabel * addLabel; //添加或是删除

@end
