//
//  HistoryWebsite.h
//  OwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryWebsite : NSObject
@property(nonatomic,assign)int htID; //标签ID 主键
@property(nonatomic,retain)NSString * htURL; //网址
@property(nonatomic,retain)NSString * htTime; //网址创建时间
@property(nonatomic,retain)NSString * htTitle; //网址标题
- (id)initWithID:(int)newID andURL:(NSString *)newURL andTitle:(NSString *)newTitle andTime:(NSString *)newTime;

+(NSMutableArray *)findAll;
+(int)addHistoryWebsiteWithURL:(NSString *)newURL
                        andTime:(NSString *)newTime
                       andTitle:(NSString *)newTitle;
+ (int)updateTitle:(NSString *)theTitle byURLString:(NSString *)theURLString;//更新标题

+ (NSMutableArray *)selectHistoryResultsWithLikeUrlString:(NSString *)newUrlString;
+ (NSString *)findUrlStringByLikeString:(NSString *)likeString;
+ (void)deleteAllHistoryWebsiteResults;

@end
