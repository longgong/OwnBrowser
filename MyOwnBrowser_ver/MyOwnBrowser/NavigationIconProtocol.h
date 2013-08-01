//
//  NavigationIconProtocol.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-2.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NavigationButton;
@protocol NavigationIconProtocol <NSObject>

@optional
- (void)whenBeginClickButtonResponse:(NavigationButton *)sender;
- (void)whenEndClickButtonResponse:(NavigationButton *)sender;

@end
