//
//  DataBase.m
//  MySQL
//
//  Created by cyy on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"

#define kDBPath @"dbBrowser.sqlite"
#define kDBName @"dbBrowser"
static sqlite3 *dbPointer = nil;

@implementation DataBase

+(sqlite3 *)openDB
{
	if(dbPointer)//如果数据库已经打开，返回数据库指针
	{
		return dbPointer;
	}
	//沙盒中sql文件的路径
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *sqlFilePath = [docPath stringByAppendingPathComponent:kDBPath];
	//原始sql文件路径
	NSString *originFilePath = [[NSBundle mainBundle] pathForResource:kDBName ofType:@"sqlite"];
	
	NSFileManager *fm = [NSFileManager defaultManager];//文件管理器
	if([fm fileExistsAtPath:sqlFilePath] == NO)//如果sql文件不在doc下，copy过来
	{
		NSError *error = nil;
		if([fm copyItemAtPath:originFilePath toPath:sqlFilePath error:&error] == NO)
		{
			NSLog(@"创建数据库的时候出现了错误：%@",[error localizedDescription]);
		}
	}
	
	NSLog(@"open db at path:%@",sqlFilePath);
	sqlite3_open([sqlFilePath UTF8String], &dbPointer);//打开数据库，并且设置其指针
	return dbPointer;
}

+(void) closeDB
{
	if(dbPointer)
	{
		sqlite3_close(dbPointer);//关闭数据库
		dbPointer = nil;
	}
}


@end
