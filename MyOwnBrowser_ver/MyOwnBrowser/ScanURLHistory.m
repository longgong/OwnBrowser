//
//  ScanURLHistory.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "ScanURLHistory.h"
#import "DataBase.h"

@implementation ScanURLHistory

- (void)dealloc
{
    [_swScanTime release];
    [_swScanURL release];
    [super dealloc];
}

- (id)initWithID:(int)newID andScanURL:(NSString *)newScanURL andScanTime:(NSString *)newScanTime andScanCount:(int)newScanCount andScanTile:(NSString *)newTitle
{
    if (self = [super init]) {
        _swID = newID;
        _swScanURL = [newScanURL retain];
        _swScanTime = [newScanTime retain];
        _swScanCount = newScanCount;
        _swTitle = [newTitle retain];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ScanHistory ID = %d, ScanURL = %@, ScanTime = %@, ScanCount = %d",self.swID,self.swScanURL,self.swScanTime,self.swScanCount];
}

//数据库操作
+ (NSMutableArray *)findAllHistoryURL
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select *from scanWebsiteHistoryTable order by swScantime desc", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            //按列查询
            int kwID = sqlite3_column_int(stmt, 0);
            const unsigned char * swScanURL = sqlite3_column_text(stmt, 1);
            const unsigned char * swTime = sqlite3_column_text(stmt, 2);
            int swScanCount = sqlite3_column_int(stmt, 3);
            const unsigned char * swTitle = sqlite3_column_text(stmt, 4);
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theScanURL = swScanURL ? [NSString stringWithUTF8String:(const char *)swScanURL] : nil;
            NSString * theTime = swTime ? [NSString stringWithUTF8String:(const char *)swTime] : nil;
            NSString * theTitle = swTitle ? [NSString stringWithUTF8String:(const char *)swTitle] : nil;
            
            ScanURLHistory * scanURL = [[ScanURLHistory alloc] initWithID:kwID andScanURL:theScanURL andScanTime:theTime andScanCount:swScanCount andScanTile:theTitle];
            [array addObject:scanURL];
            [scanURL release];
            
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else { //查找失败
        NSLog(@"数据库查询失败:%d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
    
}

+ (int)addScanHistoryURL:(NSString *)newURL andTime:(NSString *)newTime andScanTitle:(NSString *)newTitle
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result;
    sqlite3_prepare_v2(db, "select count (*) from scanWebsiteHistoryTable where swScanUrl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    
    if (count == 0) {
        sqlite3_prepare_v2(db, "insert into scanWebsiteHistoryTable(swscanurl,swScanTime,swScanCount,swTitle) values(?,?,1,?)", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, nil);
        
    } else if (count > 0){ //有存在记录则修改，更新
        
        sqlite3_prepare_v2(db, "update scanWebsiteHistoryTable set swScanCount =   (select count (*) from scanWebsiteHistoryTable where swscanurl = ?) +1 ,swscantime = ? where swscanurl = ?", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newURL UTF8String], -1, nil);
    }
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"数据库添加记录情况:%d",result);
    return result;
    
}

+ (int)updateTitle:(NSString *)theTitle byURLString:(NSString *)theURLString
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(db, "update scanWebsiteHistoryTable set swTitle = ? where swScanURL = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theTitle UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [theURLString UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"数据库更新title操作执行情况%d",result);
    sqlite3_finalize(stmt);
    
    return result;
}

+ (ScanURLHistory *)findOneScanUrlHistoryResultByUrl:(NSString *)newURL
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    sqlite3_prepare_v2(db, "select * from scanWebsiteHistoryTable where swScanUrl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    
    if (result == 100) {
        int kwID = sqlite3_column_int(stmt, 0);
        const unsigned char * swScanURL = sqlite3_column_text(stmt, 1);
        const unsigned char * swTime = sqlite3_column_text(stmt, 2);
        int swScanCount = sqlite3_column_int(stmt, 3);
        const unsigned char * swTitle = sqlite3_column_text(stmt, 4);
        
        //查询完后需要转化成OC字符才能存入数组，因而需要判空
        NSString * theScanURL = swScanURL ? [NSString stringWithUTF8String:(const char *)swScanURL] : nil;
        NSString * theTime = swTime ? [NSString stringWithUTF8String:(const char *)swTime] : nil;
        NSString * theTitle = swTitle ? [NSString stringWithUTF8String:(const char *)swTitle] : nil;
        
        ScanURLHistory * scanURL = [[ScanURLHistory alloc] initWithID:kwID andScanURL:theScanURL andScanTime:theTime andScanCount:swScanCount andScanTile:theTitle];
        NSLog(@"ScanURLHistory : %@",scanURL);
        sqlite3_finalize(stmt);
        return [scanURL autorelease];
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"ScanURLHistory查询一条记录结果 %d",result);
        return [[[ScanURLHistory alloc] init] autorelease];
    }
}

+ (NSMutableArray *)findScanHistoryRecordsWithLikeTimeSearch:(NSString *)searchTime {
    sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
	int result = sqlite3_prepare_v2(db, "select * from scanwebsiteHistorytable where swscanTime like ? order by swscantime desc", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@%%", searchTime] UTF8String], -1, nil);
	if(result == SQLITE_OK)
	{
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
			int swID = sqlite3_column_int(stmt, 0);
			const unsigned char *swURL = sqlite3_column_text(stmt, 1);
			const unsigned char *swTime = sqlite3_column_text(stmt, 2);
            int swCount = sqlite3_column_int(stmt, 3);
            const unsigned char * swTitle = sqlite3_column_text(stmt, 4);
            
            NSString * theURL = swURL ? [NSString stringWithUTF8String:(const char *)swURL] : nil;
            NSString * theTime = swTime ? [NSString stringWithUTF8String:(const char *)swTime] : nil;
            NSString * theTitle = swTitle ? [NSString stringWithUTF8String:(const char *)swTitle] : nil;
            
            ScanURLHistory * scanURL = [[ScanURLHistory alloc]initWithID:swID andScanURL:theURL andScanTime:theTime andScanCount:swCount andScanTile:theTitle];
            
			[array addObject:scanURL];
			[scanURL release];
		}
		sqlite3_finalize(stmt);
        
		return [array autorelease];
	}
	else
	{
		NSLog(@"findMatchingRecords failed with result:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
}

+ (NSMutableArray *)findScanHistoryRecordsWithNotLikeTodayTimeSearch:(NSString *)today andYesterday:(NSString *)yesterday andBoforeTime:(NSString *)beforeTime {
    sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
    
	int result = sqlite3_prepare_v2(db, "SELECT * FROM scanwebsitehistorytable where swscanTime not like ? and swscanTime not like ? and swscanTime not like ? order by swscantime desc", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@%%", today] UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@%%", yesterday] UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@%%", beforeTime] UTF8String], -1, nil);
	if(result == SQLITE_OK)
	{
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
            
			int swID = sqlite3_column_int(stmt, 0);
			const unsigned char *swURL = sqlite3_column_text(stmt, 1);
			const unsigned char *swTime = sqlite3_column_text(stmt, 2);
            int swCount = sqlite3_column_int(stmt, 3);
            const unsigned char * swTitle = sqlite3_column_text(stmt, 4);
            
            NSString * theURL = swURL ? [NSString stringWithUTF8String:(const char *)swURL] : nil;
            NSString * theTime = swTime ? [NSString stringWithUTF8String:(const char *)swTime] : nil;
            NSString * theTitle = swTitle ? [NSString stringWithUTF8String:(const char *)swTitle] : nil;
            
            ScanURLHistory * scanURL = [[ScanURLHistory alloc]initWithID:swID andScanURL:theURL andScanTime:theTime andScanCount:swCount andScanTile:theTitle];
            
			[array addObject:scanURL];
			[scanURL release];
		}
		sqlite3_finalize(stmt);
        
		return [array autorelease];
	}
	else
	{
		NSLog(@"findMatchingRecords failed with result:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
}

+ (void)deleteAllScanUrlResults
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete  from scanWebsiteHistoryTable", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"删除浏览历史数据库失败:%d",result);
    }
}

@end
