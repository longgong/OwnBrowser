//
//  KeyWordSearch.h
//  OwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyWordSearch : NSObject

@property(nonatomic,assign)int kwID; //标签ID 主键
@property(nonatomic,retain)NSString * kword; //搜索关键字
@property(nonatomic,retain)NSString * kwTime; //关键字搜索时间
@property(nonatomic,assign)int kwSearchCount; //关键字搜索次数
@property(nonatomic,retain)NSString * kwSearchEngine; //搜索引擎


- (id)initWithID:(int)newID andKeyword:(NSString *)newKeyword andSearchCount:(int)newSearchCount andTime:(NSString *)newTime andSearchEngine:(NSString *)newSearchEngine;

+ (NSMutableArray *)findAllResults; //查询数据库操作
+ (int)addKeyWordResultWithKeyword:(NSString *)newKeyword andTime:(NSString *)newTime andSearchEngine:(NSString *)newSearchEngine;//添加记录到数据库中

+ (NSMutableArray *)selectKeywordResultsWithLikeKeyword:(NSString *)newKeyword; //根据关键字模糊查询

+ (void)deleteAllKeywordResults;

@end
