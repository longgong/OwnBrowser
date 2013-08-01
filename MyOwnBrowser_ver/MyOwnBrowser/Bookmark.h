//
//  Bookmark.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject

@property(nonatomic,assign)int bmID; //书签ID
@property(nonatomic,retain)NSString * bmURL; //书签网址
@property(nonatomic,retain)NSString * bmTitle; //书签网址标题
@property(nonatomic,retain)NSString * bmAddTime; //书签添加时间

- (id)initWithID:(int)newID andURL:(NSString *)newURL andTitle:(NSString *)newTile andAddTime:(NSString *)newTime;

+ (NSMutableArray *)findAllBookmark;
+ (int)addBookmarkWithURL:(NSString *)newURL andTime:(NSString *)newTime andTitle:(NSString *)newTitle;
+ (int)updateTitle:(NSString *)newTime byURLString:(NSString *)newURL;

+ (int)findOneBookmarkByURL:(NSString *)newURL;
+ (int)addOneBookmarkWithURL:(NSString *)newURL andTime:(NSString *)newTime andTitle:(NSString *)newTitle;
+ (int)deleteOneBookmarkByURL:(NSString *)newURL;
+ (void)deleteAllBookmarkResults;

@end
