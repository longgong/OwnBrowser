//
//  HistoryAndBookmarkProtocol.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryAndBookmarkProtocol <NSObject>

@optional
- (void)showHistoryResult;
- (void)showBookmarkResult;

- (void)goBackToLeft;
- (void)forwardToRight;

- (void)doDeleteBookmark:(NSString *)str;
@end
