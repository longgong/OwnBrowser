//
//  loadWebPageProtocol.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-5.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZoomImageView;
@protocol loadWebPageProtocol <NSObject>

@optional
- (void)goBackToLoadNewPage:(ZoomImageView *)imgView;

@end
