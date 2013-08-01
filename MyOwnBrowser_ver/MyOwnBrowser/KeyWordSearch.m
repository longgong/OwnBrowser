//
//  KeyWordSearch.m
//  OwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "KeyWordSearch.h"
#import "DataBase.h"

@implementation KeyWordSearch

- (void)dealloc
{
    [_kword release];
    [_kwSearchEngine release];
    [_kwTime release];
    [super dealloc];
}

- (id)initWithID:(int)newID andKeyword:(NSString *)newKeyword andSearchCount:(int)newSearchCount andTime:(NSString *)newTime andSearchEngine:(NSString *)newSearchEngine
{
    if (self = [super init]) {
        _kwID = newID;
        _kword = [newKeyword retain];
        _kwSearchEngine = [newSearchEngine retain];
        _kwSearchCount = newSearchCount;
        _kwTime = [newTime retain];
    }
    return self;
}

- (NSString *)description
{
    NSString * string = [NSString stringWithFormat:@"Keyword id = %d, kerWord = %@, engine = %@, count = %d, time = %@",self.kwID,self.kword,self.kwSearchEngine,self.kwSearchCount,self.kwTime];
    return string;
}


#pragma mark- databaseOperate
+ (NSMutableArray *)findAllResults
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select *from keywordtable order by kwsearchcount desc", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            //按列查询
            int kwID = sqlite3_column_int(stmt, 0);
            const unsigned char * kwKeyword = sqlite3_column_text(stmt, 1);
            const unsigned char * kwTime = sqlite3_column_text(stmt, 2);
            int kwSearchCount = sqlite3_column_int(stmt, 3);
            const unsigned char * kwSearchEngine = sqlite3_column_text(stmt, 4);
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theKeyword = kwKeyword ? [NSString stringWithUTF8String:(const char *)kwKeyword] : nil;
            NSString * theTime = kwTime ? [NSString stringWithUTF8String:(const char *)kwTime] : nil;
            NSString * theSearchEngine = kwSearchEngine ? [NSString stringWithUTF8String:(const char *)kwSearchEngine] : nil;
            
            KeyWordSearch * keyWord = [[KeyWordSearch alloc] initWithID:kwID andKeyword:theKeyword andSearchCount:kwSearchCount andTime:theTime andSearchEngine:theSearchEngine];
            [array addObject:keyWord];
            [keyWord release];
            
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else { //查找失败
        NSLog(@"数据库查询失败:%d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
    
}

+ (int)addKeyWordResultWithKeyword:(NSString *)newKeyword andTime:(NSString *)newTime andSearchEngine:(NSString *)newSearchEngine
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result;
    sqlite3_prepare_v2(db, "select count (*) from keywordtable where kwkeyword = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newKeyword UTF8String], -1, nil);
    sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    
    if (count == 0) {
        NSLog(@"insert");
        sqlite3_prepare_v2(db, "insert into keywordtable(kwkeyword,kwtime,kwsearchcount,kwsearchengine) values(?,?,1,?) ", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newKeyword UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newSearchEngine UTF8String], -1, nil);
        
    } else if (count > 0){ //有存在记录则修改，更新
        NSLog(@"update");
        sqlite3_prepare_v2(db, "update keywordtable set kwsearchcount =   (select count (*) from keywordtable where kwkeyword = ?) +1,kwtime = ? where kwkeyword = ?", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newKeyword UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newKeyword UTF8String], -1, nil);
        

    }
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"数据库添加记录情况:%d",result);
    return result;
    
}

+ (NSMutableArray *)selectKeywordResultsWithLikeKeyword:(NSString *)newKeyword
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "SELECT * FROM keywordtable where kwkeyword like ? order by kwtime desc", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%%%@%%",newKeyword] UTF8String], -1, nil);
    
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            //按列查询
            int kwID = sqlite3_column_int(stmt, 0);
            const unsigned char * kwKeyword = sqlite3_column_text(stmt, 1);
            const unsigned char * kwTime = sqlite3_column_text(stmt, 2);
            int kwSearchCount = sqlite3_column_int(stmt, 3);
            const unsigned char * kwSearchEngine = sqlite3_column_text(stmt, 4);
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theKeyword = kwKeyword ? [NSString stringWithUTF8String:(const char *)kwKeyword] : nil;
            NSString * theTime = kwTime ? [NSString stringWithUTF8String:(const char *)kwTime] : nil;
            NSString * theSearchEngine = kwSearchEngine ? [NSString stringWithUTF8String:(const char *)kwSearchEngine] : nil;
            
            KeyWordSearch * keyWord = [[KeyWordSearch alloc] initWithID:kwID andKeyword:theKeyword andSearchCount:kwSearchCount andTime:theTime andSearchEngine:theSearchEngine];
            [array addObject:keyWord];
            [keyWord release];
            
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else { //查找失败
        NSLog(@"数据库查询失败:%d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
    
}

+ (void)deleteAllKeywordResults
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete  from keyWordTable", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"删除关键字数据库失败:%d",result);
    }
}

@end
