//
//  MyItemToolBar.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoLeftOrRightProtocol.h"

@class MyWebView;
@interface MyItemToolBar : UIToolbar

@property(nonatomic,retain)MyWebView * webView;

@property(nonatomic,assign)id<DoLeftOrRightProtocol> ownDelegate;

@end
