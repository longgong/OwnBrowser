//
//  HistoryWebsite.m
//  OwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "HistoryWebsite.h"
#import "DataBase.h"

@implementation HistoryWebsite
- (void)dealloc
{
    [_htTime release];
    [_htTitle release];
    [_htURL release];
    [super dealloc];
}

- (id)initWithID:(int)newID andURL:(NSString *)newURL andTitle:(NSString *)newTitle andTime:(NSString *)newTime
{
    if (self = [super init]) {
        _htID = newID;
        _htTime = [newTime retain];
        _htTitle = [newTitle retain];
        _htURL = [newURL retain];
    }
    
    return self;
}

- (NSString *)description
{
    NSString * str = [NSString stringWithFormat:@"ID = %d, URL = %@, Time = %@, Title = %@",self.htID,self.htURL,self.htTime,self.htTitle];
    return str;
}

#pragma mark student表的操作
+(NSMutableArray *)findAll
{
    
	sqlite3 *db = [DataBase openDB];
	
	sqlite3_stmt *stmt = nil;
    
	int result = sqlite3_prepare_v2(db, "select * from historyWebsiteTable order by httime desc", -1, &stmt, nil);
	if(result == SQLITE_OK)
	{
		
		NSMutableArray *stuArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
            
			int htID = sqlite3_column_int(stmt, 0);
			const unsigned char * htURL = sqlite3_column_text(stmt, 1);
			const unsigned char * htTime = sqlite3_column_text(stmt, 2);
            const unsigned char * htTitle = sqlite3_column_text(stmt, 3);
            
            //判空操作
            NSString * theURL = htURL ? [NSString stringWithUTF8String:(const char *)htURL] : nil;
            NSString * theTime = htTime ?[NSString stringWithUTF8String:(const char *)htTime] : nil;
            NSString * thtTitle = htTitle ? [NSString stringWithUTF8String:(const char *)htTitle] : nil;
            
			HistoryWebsite * webSite = [[HistoryWebsite alloc]initWithID:htID andURL:theURL andTitle:thtTitle andTime:theTime];
			[stuArray addObject:webSite];
			[webSite release];
		}
		sqlite3_finalize(stmt);
        
		return [stuArray autorelease];
	}
	else
	{
		NSLog(@"find all failed with result:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
	}
}

+(int)addHistoryWebsiteWithURL:(NSString *)newURL
                 andTime:(NSString *)newTime
                andTitle:(NSString *)newTitle
{
    
	sqlite3 *db = [DataBase openDB];
	sqlite3_stmt *stmt = nil;
    
    sqlite3_prepare_v2(db, "select count(*) from historywebsitetable where hturl =?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    NSLog(@"%@, count = %d",newURL,count);
    if (count == 0) { //没有该网址记录
        
        sqlite3_prepare_v2(db, "insert into historyWebsiteTable(htURL,htTime,htTitle) values(?,?,?)", -1, &stmt, nil);
        
        sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, nil);
        result = sqlite3_step(stmt);
        
    } else if (count > 0){ //数据库中有该网址记录
        sqlite3_prepare_v2(db, "update historywebsitetable set httime = ? where hturl = ?", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newURL UTF8String], -1, nil);
        result = sqlite3_step(stmt);
    }

	sqlite3_finalize(stmt);
    NSLog(@"%d",result);
	return result;
}

+ (int)updateTitle:(NSString *)theTitle byURLString:(NSString *)theURLString
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(db, "update historywebsitetable set httitle = ? where hturl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theTitle UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [theURLString UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"数据库更新title操作执行情况%d",result);
    sqlite3_finalize(stmt);
    
    return result;
}

+ (NSMutableArray *)selectHistoryResultsWithLikeUrlString:(NSString *)newUrlString
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "SELECT * FROM historywebsitetable where hturl like ? order by httime desc", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%%%@%%",newUrlString] UTF8String], -1, nil);
    
    if (SQLITE_OK == result) {
        
        NSMutableArray *stuArray = [[NSMutableArray alloc] init];
		while(SQLITE_ROW == sqlite3_step(stmt))
		{
			int htID = sqlite3_column_int(stmt, 0);
			const unsigned char * htURL = sqlite3_column_text(stmt, 1);
			const unsigned char * htTime = sqlite3_column_text(stmt, 2);
            const unsigned char * htTitle = sqlite3_column_text(stmt, 3);
            
            //判空操作
            NSString * theURL = htURL ? [NSString stringWithUTF8String:(const char *)htURL] : nil;
            NSString * theTime = htTime ?[NSString stringWithUTF8String:(const char *)htTime] : nil;
            NSString * thtTitle = htTitle ? [NSString stringWithUTF8String:(const char *)htTitle] : nil;
            
			HistoryWebsite * webSite = [[HistoryWebsite alloc]initWithID:htID andURL:theURL andTitle:thtTitle andTime:theTime];
			[stuArray addObject:webSite];
			[webSite release];
		}
		sqlite3_finalize(stmt);
        
		return [stuArray autorelease];
        
    } else {
        
        NSLog(@"find all failed with result:%d",result);
		sqlite3_finalize(stmt);
		return [NSMutableArray array];
        
    }
    
}

+ (void)deleteAllHistoryWebsiteResults
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete  from historywebsitetable", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"删除输入网址数据库失败:%d",result);
    }
}

+ (NSString *)findUrlStringByLikeString:(NSString *)likeString
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "SELECT hturl FROM historywebsitetable where hturl like ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%%%@%%",likeString] UTF8String], -1, nil);
    if (SQLITE_OK == result) {
        sqlite3_step(stmt);
        
        const unsigned char * htURL = sqlite3_column_text(stmt, 0);
        //判空操作
        NSString * theURL = htURL ? [NSString stringWithUTF8String:(const char *)htURL] : nil;
        sqlite3_finalize(stmt);
        return theURL;
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"history like find error : %d",result);
        return nil;
    }
}

@end
