//
//  DataBase.h
//  MySQL
//
//  Created by cyy on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 此类用于打开以及关闭数据库
 
 数据库做成了一个单例，方便频繁操作数据库
 */
//插入一条信息
//insert into movietable(mname,mid,mtime) values('中国合伙人',5,480)
//更新
//update movietable set mname = '中国合伙人2' where mid = 5
//update movietable set mname = '中国合伙人3' ,mtime = 240 where mid = 5
//update movietable set mtime = 120 where mname = '中国合伙人3'
//update movietable set mtime = 240 , mid = 6 where mname = '中国合伙人3'
//删除
//delete from movietable where mid = 6
//delete from movietable where mname = 'a'
//查
//select mtime from movietable where mname = '致青春'
//select * from movietable where mname like '致青春%'
//select * from movietable where mname like '%致青春'
//select * from movietable where mname like '%致青春%'
//select count(*) from movietable
//查询符合某个条件的信息有多少条
//select count(*) from movietable where mname = '致青春'

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject 


//open the database
+(sqlite3 *)openDB;

//close the database
+(void) closeDB;
@end
