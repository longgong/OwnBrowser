//
//  Singleton.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-26.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (Singleton *)shareSingleton
{
    static Singleton * single = nil;
    if (!single) {
        single = [[Singleton alloc] init];
        
    }
    return single;
}

@end

/*
 NSURL * iconURL = [[NSURL alloc] initWithScheme:[webView.request.URL scheme] host:[webView.request.URL host] path:@"/favicon.ico"];下载webview加载网址的icon图片
 */