//
//  BottomBookMarkToolbar.h
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryAndBookmarkProtocol.h"

@interface BottomBookMarkToolbar : UIToolbar

@property(nonatomic,assign)id<HistoryAndBookmarkProtocol> itemDelegate; //代理
@property(nonatomic,retain) UISegmentedControl * segmentCtrl;
@end
