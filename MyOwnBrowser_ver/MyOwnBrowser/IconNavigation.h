//
//  IconNavigation.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-2.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconNavigation : NSObject

@property(nonatomic,assign)int niID;  //导航信息表主键
@property(nonatomic,retain)NSString * niTitle; //网站标题
@property(nonatomic,retain)NSString * niIconString; //图标名称，不带格式
@property(nonatomic,retain)NSString * niIconFormatter; //图标格式
@property(nonatomic,retain)NSString * niIconURL; //导航网址
@property(nonatomic,assign)int niIconInsertNumber; //图标填充顺序

- (id)initWithID:(int)newID andTitle:(NSString *)newTitle andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andIconURL:(NSString *)newIconURL andIconInsertNumber:(int)newIconInsetNumber;

+ (NSMutableArray *)findAllIconInfos;
+ (int)addOneIconWithURL:(NSString *)newURL andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andTitle:(NSString *)newTitle;
+ (int)addFirstIconWithURL:(NSString *)newURL andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andTitle:(NSString *)newTitle;

+ (void)deleteAllLoadIconResultsByID:(int)theID;//删除比id大得记录
+ (int)findOneIconName:(NSString *)theIconName;
@end
