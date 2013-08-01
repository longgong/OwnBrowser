//
//  Singleton.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-26.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageViewController.h"
#import "LeftViewController.h"
#import "NewPage.h"

@interface Singleton : NSObject

@property(nonatomic,retain)HomePageViewController * homepageVC;
@property(nonatomic,assign)LeftViewController * leftPageVC;
@property(nonatomic,assign)int showNumber; //页面显示编号

@property(nonatomic,retain)NewPage * defaultPage;
@property(nonatomic,assign)BOOL refreshUIDatas; //重新加载导航按钮，YES重加载

@property(nonatomic,assign)BOOL isSavingScanUrlHistroy;//是否开启保存访问记录，yes开启
@property(nonatomic,assign)BOOL isOpenPropmtMusic;// 是够开启提示音，默认不开启，yes开启

@property(nonatomic,assign)BOOL isAddingFail; //导航按钮是否添加失败，yes添加失败
@property(nonatomic,retain)NSString * navigationIconName; //导航图标名字

+ (Singleton *)shareSingleton;

@end
