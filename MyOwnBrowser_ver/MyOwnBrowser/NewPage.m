//
//  NewPage.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-4.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "NewPage.h"
#import "DataBase.h"

@implementation NewPage

- (void)dealloc
{
    [_npAddTime release];
    [_npUrlString release];
    [_npFileName release];
    [super dealloc];
}

- (id)initWithID:(int)newID andURLString:(NSString *)newURLString andAddTime:(NSString *)newAddTime andWindowNum:(int)newNum andFileName:(NSString *)newFileName
{
    if (self = [super init]) {
        _npID = newID;
        _npAddTime = [newAddTime retain];
        _npUrlString = [newURLString retain];
        _npWindowNum = newNum;
        _npFileName = [newFileName retain];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"newpage newid = %d, urlstring = %@, addtime = %@, filename = %@, winnum = %d",self.npID,self.npUrlString,self.npAddTime,self.npFileName,self.npWindowNum];
}

+ (NSMutableArray *)findAllPages
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select *from newpagetable order by npwindowNum asc", -1, &stmt, nil); //升序放入数组
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            //按列查询
            int npID = sqlite3_column_int(stmt, 0);
            const unsigned char * npURLString = sqlite3_column_text(stmt, 1);
            const unsigned char * npAddTime = sqlite3_column_text(stmt, 2);
            int npWindowNum = sqlite3_column_int(stmt, 3);
            const unsigned char * npFileName = sqlite3_column_text(stmt, 4);
            
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theURLString = npURLString ? [NSString stringWithUTF8String:(const char *)npURLString] : nil;
            NSString * theTime = npAddTime ? [NSString stringWithUTF8String:(const char *)npAddTime] : nil;
            NSString * theFileName = npFileName ? [NSString stringWithUTF8String:(const char *)npFileName] : nil;
            
            NewPage * page = [[NewPage alloc] initWithID:npID andURLString:theURLString andAddTime:theTime andWindowNum:npWindowNum andFileName:theFileName];
            [array addObject:page];
            [page release];
            
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else { //查找失败
        NSLog(@"数据库NewPageTable查询失败:%d",result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
 
}

//添加新页面
+ (int)addNewPageWithURLString:(NSString *)newURLString andTime:(NSString *)newTime andFileName:(NSString *)newFileName
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    
    
    sqlite3_prepare_v2(db, "insert into newpagetable(npurlstring,npaddtime,npwindownum,npfileName) values(?,?,1,?)", -1, &stmt, nil); //默认插入第一个
    sqlite3_bind_text(stmt, 1, [newURLString UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [newFileName UTF8String], -1, nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"NewPageTable表添加新页面记录情况:%d",result);
    return result;
}

//添加新页面2
+ (int)addNewPageWithURLString:(NSString *)newURLString andTime:(NSString *)newTime andFileName:(NSString *)newFileName andWindowNum:(int)newNum
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    
    
    sqlite3_prepare_v2(db, "insert into newpagetable(npurlstring,npaddtime,npwindownum,npfileName) values(?,?,?,?)", -1, &stmt, nil); //默认插入第一个
    sqlite3_bind_text(stmt, 1, [newURLString UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 3, newNum);
    sqlite3_bind_text(stmt, 4, [newFileName UTF8String], -1, nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"NewPageTable表添加新页面记录情况:%d",result);
    return result;
}

//删除页面
+ (int)deleteOnePageByWindowNum:(int)newWindowNum
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from newpagetable where npwindownum = ?", -1, &stmt, nil);
    sqlite3_bind_int(stmt, 1, newWindowNum);
    int result = sqlite3_step(stmt);
    NSLog(@"newPageTable 删除旧页面结果:%d",result);
    return result;
}

//更新页面
+ (int)updatePageUrlString:(NSString *)urlString andTime:(NSString *)newTime ByWindowNum:(int)newWindowNum //更新 名字不用修改
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(db, "update newpagetable set npurlstring = ?, npAddTime = ? where npwindownum = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [urlString UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newTime UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 3, newWindowNum);
    int result = sqlite3_step(stmt);
    NSLog(@"数据库更新title操作执行情况%d",result);
    sqlite3_finalize(stmt);
    
    return result;
}

+ (int)findAllWindowRows
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "SELECT count(*) from newpagetable", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    int count = sqlite3_column_int(stmt, 0);
    NSLog(@"newpage执行查找行记录结果 : %d",result);
    return count;
}

+ (int)deleteAllPages
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from newpagetable", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    NSLog(@"newPageTable 删除全部页面结果:%d",result);
    return result;
}

@end
