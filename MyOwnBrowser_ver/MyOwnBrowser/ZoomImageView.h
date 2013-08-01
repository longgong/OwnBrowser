//
//  ZoomImageView.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-5.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loadWebPageProtocol.h"

@interface ZoomImageView : UIImageView<loadWebPageProtocol>

@property(nonatomic,retain)NSString * urlString;
@property(nonatomic,assign)int windowNumber;
@property(nonatomic,assign)id<loadWebPageProtocol> forwardDelegate;

@property(nonatomic,retain)NSString * windowName; //窗口名字

@end
