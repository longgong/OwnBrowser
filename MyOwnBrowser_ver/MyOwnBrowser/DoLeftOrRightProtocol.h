//
//  DoLeftOrRightProtocol.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DoLeftOrRightProtocol <NSObject>

@optional
- (void)pushLeftViewController;  //推向左侧视图代理方法
- (void)pushRightViewController; //推向右侧视图代理方法
- (void)recordBookmark;  //设置书签代理方法
@end
