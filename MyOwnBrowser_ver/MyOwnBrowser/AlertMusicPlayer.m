//
//  AlertMusicPlayer.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-7.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "AlertMusicPlayer.h"
#import "Singleton.h"

@implementation AlertMusicPlayer

+ (AlertMusicPlayer *)defaultAlertMusicPlayer
{
    static AlertMusicPlayer * alertPlayer = nil;
    if (!alertPlayer) {
        alertPlayer = [[AlertMusicPlayer alloc] init];
        
    }
    
    return alertPlayer;
}


- (void)automaticalJudgingPlay //自动判断是否播放
{
    Singleton * single = [Singleton shareSingleton];
    if (single.isOpenPropmtMusic) {
        NSLog(@"bofang");
        [_alertPalyer play];
    } else {
        [_alertPalyer stop];
    }
}

@end
