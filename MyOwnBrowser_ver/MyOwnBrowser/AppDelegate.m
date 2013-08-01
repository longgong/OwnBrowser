//
//  AppDelegate.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NewPage.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    HomePageViewController * homePageVC = [[HomePageViewController alloc] init];
    PPRevealSideViewController * revealVC = [[PPRevealSideViewController alloc] initWithRootViewController:homePageVC];
    self.window.rootViewController = revealVC;
    [homePageVC release];
    [revealVC release];
    
    
//    NSString * path1 = [[NSBundle mainBundle] pathForResource:@"" ofType:@"" inDirectory:@"navigationBtnIcon"];
//    
//    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString * path2 = [docPath stringByAppendingPathComponent:@"navigationBtnIcon"];
//    
//    NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString * originalPath = [bundlePath stringByAppendingPathComponent:@"navigationBtnIcon"];
//    
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath:path2]) {
//        
//        if (![fileManager copyItemAtPath:originalPath toPath:path2 error:nil]) {
//            NSLog(@"copy error");
//        }
//        
//    }
    
    
    //2.获取缩略图
    
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 50, 100, 200)];
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"JD" ofType:@"png" inDirectory:@"navigationBtnIcon"];
//    UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];
//    imgView.image = img;
//    [img release];
//    [self.window addSubview:imgView];
//    
//    
//    imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 250, 100, 150)];
//    [img release];
//    [self.window addSubview:imgView1];
    
    

    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [NewPage deleteAllPages];
    NSLog(@"app stop");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.window];
    if (CGRectContainsPoint(imgView.frame, point)) {
        NSLog(@"imgview");
        imgView1.image = [self screenShot:imgView.frame.size andView:imgView];
    } else {
        NSLog(@"edad");
        imgView1.image = [self screenShot:self.window.frame.size andView:self.window];
    }
}

//获取指定视图指定区域的截图
- (UIImage *)screenShot:(CGSize)size andView:(UIView *)aView
{ //截屏
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [aView.layer renderInContext:context]; //把区域的信息写到context中
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

@end
