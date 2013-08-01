//
//  NavigationButton.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-30.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationIconProtocol.h"

@interface NavigationButton : UIControl
{
    @private
    UIImageView * imgView; //图片视图;
}

@property(nonatomic,retain)UILabel * titleLabel; //显示标题
@property(nonatomic,retain)UIImage * img; //显示图片
@property(nonatomic,assign)id<NavigationIconProtocol> iconDelegate;
@property(nonatomic,retain)NSString * urlString; //保存网址

@end
