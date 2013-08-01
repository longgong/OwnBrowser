//
//  Bookmark.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "Bookmark.h"
#import "DataBase.h"

@implementation Bookmark

- (id)initWithID:(int)newID andURL:(NSString *)newURL andTitle:(NSString *)newTile andAddTime:(NSString *)newTime
{
    if (self = [super init]) {
        _bmID = newID;
        _bmURL = [newURL retain];
        _bmTitle = [newTile retain];
        _bmAddTime = [newTime retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_bmURL release];
    [_bmTitle release];
    [_bmAddTime release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"bookmark操作:id = %d, url = %@, title = %@, time = %@",_bmID,self.bmURL,self.bmTitle,self.bmAddTime];
}

//数据库操作
+ (NSMutableArray *)findAllBookmark
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select *from bookmarktable order by bmaddtime desc", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            //按列查询
            int bmID = sqlite3_column_int(stmt, 0);
            const unsigned char * bmURL = sqlite3_column_text(stmt, 1);
            const unsigned char * bmTitle = sqlite3_column_text(stmt, 2);
            const unsigned char * bmTime = sqlite3_column_text(stmt, 3);
            
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theURL = bmURL ? [NSString stringWithUTF8String:(const char *)bmURL] : nil;
            NSString * theTime = bmTime ? [NSString stringWithUTF8String:(const char *)bmTime] : nil;
            NSString * theTitle = bmTitle ? [NSString stringWithUTF8String:(const char *)bmTitle] : nil;
            
            Bookmark * bookmark = [[Bookmark alloc] initWithID:bmID andURL:theURL andTitle:theTitle andAddTime:theTime];
            [array addObject:bookmark];
            [bookmark release];
            
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else { //查找失败
        NSLog(@"数据库查询失败:%d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
    
}

//查询某记录
+ (int)findOneBookmarkByURL:(NSString *)newURL
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = 0;
    sqlite3_prepare_v2(db, "select count (*) from bookmarktable where bmUrl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    result = sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    NSLog(@"bookMark 查询一条记录:%d",result);
    
    return count;  //1代表有记录，0代表无记录
}

//添加书签
+ (int)addOneBookmarkWithURL:(NSString *)newURL andTime:(NSString *)newTime andTitle:(NSString *)newTitle
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    sqlite3_prepare_v2(db, "insert into bookmarktable(bmUrl,bmaddTime,bmTitle) values(?,?,?)", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"bookmark表添加记录情况:%d",result);
    return result;
}

//删除书签
+ (int)deleteOneBookmarkByURL:(NSString *)newURL
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from bookmarktable where bmurl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"bookmark 删除书签结果:%d",result);
    return result;
}


//增加书签，可重复添加
+ (int)addBookmarkWithURL:(NSString *)newURL andTime:(NSString *)newTime andTitle:(NSString *)newTitle
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result;
    sqlite3_prepare_v2(db, "select count (*) from bookmarktable where bmUrl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
    sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    
    if (count == 0) {
        sqlite3_prepare_v2(db, "insert into bookmarktable(bmUrl,bmaddTime,bmTitle) values(?,?,?)", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newURL UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, nil);
        
    } else if (count > 0){ //有存在记录则修改，更新
        
        sqlite3_prepare_v2(db, "update bookmarktable set bmaddTime = ? where bmurl = ?", -1, &stmt, nil);
        sqlite3_bind_text(stmt, 1, [newTime UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [newURL UTF8String], -1, nil);
    }
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"bookmark表添加记录情况:%d",result);
    return result;
    
}

+ (int)updateTitle:(NSString *)newTime byURLString:(NSString *)newURL
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(db, "update bookmarktable set bmaddtime = ? where bmurl = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newTime UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newURL UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"数据库更新title操作执行情况%d",result);
    sqlite3_finalize(stmt);
    
    return result;
}

+ (void)deleteAllBookmarkResults
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete  from bookmarktable", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"删除书签数据库失败:%d",result);
    }
}

@end
