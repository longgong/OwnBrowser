//
//  ScanURLHistory.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanURLHistory : NSObject

@property(nonatomic,assign)int swID; //浏览网页历史ID
@property(nonatomic,retain)NSString * swScanURL; //浏览网页url
@property(nonatomic,retain)NSString * swScanTime; //浏览时间
@property(nonatomic,assign)int swScanCount; //浏览次数
@property(nonatomic,retain)NSString * swTitle; //网页标题

- (id)initWithID:(int)newID andScanURL:(NSString *)newScanURL andScanTime:(NSString *)newScanTime andScanCount:(int)newScanCount andScanTile:(NSString *)newTitle;

+ (int)addScanHistoryURL:(NSString *)newURL andTime:(NSString *)newTime andScanTitle:(NSString *)newTitle;
+ (NSMutableArray *)findAllHistoryURL;
+ (int)updateTitle:(NSString *)theTitle byURLString:(NSString *)theURLString;
+ (ScanURLHistory *)findOneScanUrlHistoryResultByUrl:(NSString *)newURL;

+ (NSMutableArray *)findScanHistoryRecordsWithLikeTimeSearch:(NSString *)searchTime; //根据时间模糊查询相应的记录

+ (NSMutableArray *)findScanHistoryRecordsWithNotLikeTodayTimeSearch:(NSString *)today andYesterday:(NSString *)yesterday andBoforeTime:(NSString *)beforeTime;//根据时间查询不实这几天的记录

+ (void)deleteAllScanUrlResults;

@end
