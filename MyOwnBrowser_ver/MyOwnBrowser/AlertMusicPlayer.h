//
//  AlertMusicPlayer.h
//  MyOwnBrowser
//
//  Created by gdm on 13-7-7.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AlertMusicPlayer : NSObject

@property(nonatomic,retain)AVAudioPlayer * alertPalyer;

+ (AlertMusicPlayer *)defaultAlertMusicPlayer;

- (void)automaticalJudgingPlay;

@end
