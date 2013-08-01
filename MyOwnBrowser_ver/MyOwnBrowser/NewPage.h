//
//  NewPage.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-4.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewPage : NSObject

@property(nonatomic,assign)int npID; //id
@property(nonatomic,retain)NSString * npUrlString; //页面网址
@property(nonatomic,retain)NSString * npAddTime; //创建时间
@property(nonatomic,assign)int npWindowNum; //窗口编号
@property(nonatomic,retain)NSString * npFileName; //文件名

- (id)initWithID:(int)newID andURLString:(NSString *)newURLString andAddTime:(NSString *)newAddTime andWindowNum:(int)newNum andFileName:(NSString *)newFileName;

+ (NSMutableArray *)findAllPages;

+ (int)addNewPageWithURLString:(NSString *)newURLString andTime:(NSString *)newTime andFileName:(NSString *)newFileName;

+ (int)deleteOnePageByWindowNum:(int)newWindowNum;

+ (int)updatePageUrlString:(NSString *)urlString andTime:(NSString *)newTime ByWindowNum:(int)newWindowNum;

//添加新页面2,加窗口编号
+ (int)addNewPageWithURLString:(NSString *)newURLString andTime:(NSString *)newTime andFileName:(NSString *)newFileName andWindowNum:(int)newNum;
+ (int)findAllWindowRows;
+ (int)deleteAllPages;
@end
