//
//  MySearchToolBar.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySearchToolBar : UIToolbar

@property(nonatomic,retain)UISearchBar * urlSearchBar; //URL搜索条
@property(nonatomic,retain)UISearchBar * keywordSearchBar; //关键字搜索条

@property(nonatomic,retain)UISearchDisplayController * urlSearchController; //URL搜索视图控制器
@property(nonatomic,retain)UISearchDisplayController * keywordSearchController; //关键字搜索视图控制器

@property(nonatomic,retain)UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate> * rootViewController; //ToolBar所在视图控制器，并且该视图控制器要实现代理

- (void)mySearchBarWillBeginSearch:(UISearchDisplayController *)controller;
- (void)mySearchBarDidBeginSearch:(UISearchDisplayController *)controller;
- (void)mySearchBarWillEndSearch:(UISearchDisplayController *)controller;
- (void)mySearchBarDidEndSearch:(UISearchDisplayController *)controller;

- (void)setActiveWithUrlSearchCtrlandKeywordSearchCtrl:(BOOL)active;

@end
