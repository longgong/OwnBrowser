//
//  IconNavigation.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-2.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "IconNavigation.h"
#import "DataBase.h"

@implementation IconNavigation

- (void)dealloc
{
    [_niIconFormatter release];
    [_niIconString release];
    [_niIconURL release];
    [_niTitle release];
    [super dealloc];
}


- (id)initWithID:(int)newID andTitle:(NSString *)newTitle andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andIconURL:(NSString *)newIconURL andIconInsertNumber:(int)newIconInsetNumber
{
    if (self = [super init]) {
        _niID = newID;
        _niIconFormatter = [newIconFormatter retain];
        _niIconString = [newIconString retain];
        _niIconURL = [newIconURL retain];
        _niTitle = [newTitle retain];
        _niIconInsertNumber = newIconInsetNumber;
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"id = %d, url = %@, title = %@, iconstring = %@, iconformatter = %@, insertnumber = %d",self.niID,self.niIconURL,self.niTitle,self.niIconString,self.niIconFormatter,self.niIconInsertNumber];
}

//按插入顺序 已排好序
+ (NSMutableArray *)findAllIconInfos
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "SELECT * FROM navigationInfoTable order by niIconInsertNumber", -1, &stmt, nil);
    if (SQLITE_OK == result) {
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            //按列查询
            int niID = sqlite3_column_int(stmt, 0);
            const unsigned char * niTitle = sqlite3_column_text(stmt, 1);
            const unsigned char * niIconString = sqlite3_column_text(stmt, 2);
            const unsigned char * niIconFormatter = sqlite3_column_text(stmt, 3);
            const unsigned char * niURL = sqlite3_column_text(stmt, 4);
            int niIconInsertNumber = sqlite3_column_int(stmt, 5);
            
            //查询完后需要转化成OC字符才能存入数组，因而需要判空
            NSString * theURL = niURL ? [NSString stringWithUTF8String:(const char *)niURL] : nil;
            NSString * theIconString = niIconString ? [NSString stringWithUTF8String:(const char *)niIconString] : nil;
            NSString * theTitle = niTitle ? [NSString stringWithUTF8String:(const char *)niTitle] : nil;
            NSString * theIconFormatter = niIconFormatter ? [NSString stringWithUTF8String:(const char *)niIconFormatter] : nil;
            
            IconNavigation * icon = [[IconNavigation alloc] initWithID:niID andTitle:theTitle andIconString:theIconString andIconFormatter:theIconFormatter andIconURL:theURL andIconInsertNumber:niIconInsertNumber];
            [array addObject:icon];
            [icon release];
 
        }
        
        sqlite3_finalize(stmt);
        return [array autorelease];
        
    } else {
        NSLog(@"%s, find error %d",__FUNCTION__,result);
        sqlite3_finalize(stmt);
        return [NSMutableArray array];
    }
}

//添加一条导航记录
+ (int)addOneIconWithURL:(NSString *)newURL andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andTitle:(NSString *)newTitle
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    sqlite3_prepare_v2(db, "insert into navigationInfoTable(niTitle,niIconString,niIconFormatter,niiconURL,niIconInsertNumber) values(?,?,?,?, (select max(niiconinsertnumber) from navigationInfoTable) +1 )", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newTitle UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newIconString UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [newIconFormatter UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 4, [newURL UTF8String], -1, nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"iconNavigation表添加记录情况:%d",result);
    return result;
}

//数据库中没有记录才调用一次该方法
+ (int)addFirstIconWithURL:(NSString *)newURL andIconString:(NSString *)newIconString andIconFormatter:(NSString *)newIconFormatter andTitle:(NSString *)newTitle 
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    
    sqlite3_prepare_v2(db, "insert into navigationInfoTable(niTitle,niIconString,niIconFormatter,niiconURL,niIconInsertNumber) values(?,?,?,?,1)", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [newTitle UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [newIconString UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [newIconFormatter UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 4, [newURL UTF8String], -1, nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"iconNavigation表添加记录情况:%d",result);
    return result;
}

// select max(niiconinsertnumber) from navigationInfoTable

+ (void)deleteAllLoadIconResultsByID:(int)theID
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete  from navigationInfoTable where niID > ?", -1, &stmt, nil);
    sqlite3_bind_int(stmt, 1, theID);
    if (SQLITE_OK == result) {
        result = sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
        NSLog(@"删除浏览历史数据库失败:%d",result);
    }
}

+ (int)findOneIconName:(NSString *)theIconName
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db, "SELECT count(*) FROM navigationInfoTable where niIconString = ?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theIconName UTF8String], -1, nil);
    sqlite3_step(stmt);
    int num = sqlite3_column_int(stmt, 0);
    NSLog(@"KKKKKK %d",result);
    return num;
}

@end
