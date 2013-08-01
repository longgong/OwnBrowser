//
//  MyWebView.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "MyWebView.h"
#import "MySearchToolBar.h"
#import "MyItemToolBar.h"
#import "HistoryWebsite.h"
#import "AlertMusicPlayer.h"
#import "PresentView.h"
#import <QuartzCore/QuartzCore.h>

#define kShowTopToolBar CGRectMake(0, 0, 320, 44)
#define kHiddenTopToolBar CGRectMake(0, -44, 320, 44)

#define kShowBottomToolBar CGRectMake(0, 460-44, 320, 44)
#define kHiddenBottomToolBar CGRectMake(0, 460, 320, 44)

#define kUrlHistoryPlist @"urlHistory.plist"

@implementation MyWebView

- (void)dealloc
{
    [_indicatorView release];
    [_theBottomToolBar release];
    [_theTopSearchToolBar release];
    [_searchURLString release];
    [_imgV release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //活动指示器控件
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(160, 230);
        [self addSubview:_indicatorView];
        
//        self.scalesPageToFit = YES;
        _isShowToolBar = YES; //默认是显示
        self.scrollView.bounces = YES;
        self.scrollView.scrollsToTop = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTapAction)];
        tapGesture.numberOfTouchesRequired = 2;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChangeDefaultWebsite:)];
        tap.numberOfTapsRequired = 3;
        [self addGestureRecognizer:tap];
        [tap release];
        
        
//        UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(280, 460-44-50, 40, 50)];
//        aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(270, 460-44-50, 40, 50)];
        _imgV.image = [UIImage imageNamed:@"v1.png"];
        _imgV.highlightedImage = [UIImage imageNamed:@"v2"];
        _imgV.userInteractionEnabled = YES;
        _imgV.hidden = YES;
        _imgV.layer.cornerRadius = 5.0f;
        
        UIButton * tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tapBtn.backgroundColor = [UIColor clearColor];
        tapBtn.frame = CGRectMake(0, 0, 40, 50);
        [tapBtn addTarget:self action:@selector(goScrollToTopDown:) forControlEvents:UIControlEventTouchDown];
        [tapBtn addTarget:self action:@selector(goScrollToTop:) forControlEvents:UIControlEventTouchUpInside];
        [_imgV addSubview:tapBtn];
        [self addSubview:_imgV];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIActivityIndicatorViewOpen&close
- (void)openIndicatorView
{
    [_indicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)closeIndicatorView
{
    [_indicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark- 手势动作
- (void)goTapAction
{
    _isHiddenToolBar = !_isHiddenToolBar;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    if (_isHiddenToolBar) { //yes隐藏工具栏
        
        _theTopSearchToolBar.frame = kHiddenTopToolBar;
        _theBottomToolBar.frame = kHiddenBottomToolBar;
    } else {
        
        _theTopSearchToolBar.frame = kShowTopToolBar;
        _theBottomToolBar.frame = kShowBottomToolBar;
        
    }
    [UIView commitAnimations];
    
    if (_isHiddenToolBar) { //yes隐藏
        
        self.frame = CGRectMake(0, 0, 320, 460);
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 44, 320, 460);
        } completion:^(BOOL finished) {
            self.frame = CGRectMake(0, 44, 320, 460-88);
//            self.scrollView.contentSize = CGSizeMake(320, 460-88);
            
        }];
        
        
        
    }
}

//修改网页默认设置
- (void)goChangeDefaultWebsite:(UITapGestureRecognizer *)sender
{
    NSString * urlString = [self.request.URL absoluteString];
    //存入本地
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"defaultWebsite.plist"];
    
    BOOL success = [urlString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    AlertMusicPlayer * alertMP = [AlertMusicPlayer defaultAlertMusicPlayer];
    [alertMP automaticalJudgingPlay];
    if (success) {
        
        PresentView * preView = [[PresentView alloc] initWithFrame:CGRectMake(110, 460, 100, 40)];
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        aLabel.text = @"默认网址设置成功";
        aLabel.textColor = [UIColor yellowColor];
        preView.titleLabel = aLabel;
        [self.window addSubview:preView];
        
        [aLabel release];
        
        [UIView animateWithDuration:1.0f animations:^{
            preView.frame = CGRectMake(110, 380, preView.frame.size.width, preView.frame.size.height);
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(goRemoveView:) userInfo:@{@"view":preView} repeats:NO];
        }];
        
        //设置成功截取缩略图,并存入documents文件夹
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        UIImage * defaultImg = [self screenShot:self.frame.size andView:self];
        NSData * defaultImgData = UIImagePNGRepresentation(defaultImg);
        [defaultImgData writeToFile:[docPath stringByAppendingPathComponent:@"defaultPage.png"] atomically:YES]; //写入文件
        
        
    } else {
        PresentView * preView = [[PresentView alloc] initWithFrame:CGRectMake(110, 460, 100, 40)];
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        aLabel.text = @"设置失败";
        aLabel.textColor = [UIColor redColor];
        preView.titleLabel = aLabel;
        [self.window addSubview:preView];
        
        [aLabel release];
        
        [UIView animateWithDuration:1.0f animations:^{
            preView.frame = CGRectMake(110, 380, preView.frame.size.width, preView.frame.size.height);
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(goRemoveView:) userInfo:@{@"view":preView} repeats:NO];
        }];

    }
}

- (void)goRemoveView:(NSNotification *)notification
{
    PresentView * view = [notification.userInfo objectForKey:@"view"];
    [view removeFromSuperview];
    [view release];
}

#pragma mark - LoadWeb
- (void)loadUrlWebSite:(NSString *)theURL
{
    NSString * urlString = [self judgeUrlString:theURL];
    self.searchURLString = urlString;  //用于plist文件写入
    NSURL * url = [NSURL URLWithString:urlString];
    [self loadRequest:[NSURLRequest requestWithURL:url]];

    //存入数据库
    NSString * currentTime = [self getCurrentStringDate];
    [HistoryWebsite addHistoryWebsiteWithURL:urlString andTime:currentTime andTitle:nil];
}

//判断输入的网址
- (NSString * )judgeUrlString:(NSString *)str
{ //http://www
    NSRange range = [str rangeOfString:@"www." options:NSCaseInsensitiveSearch];
    NSRange rangeh = [str rangeOfString:@"http://" options:NSCaseInsensitiveSearch];
    NSString * string = nil;
    if (range.length > 0 && (range.location ==0 || range.location == 7)) {
        
        NSString * subString = [str substringFromIndex:range.location];
        string = [@"http://" stringByAppendingString:subString];   //获取网址字符串
        
    } else if(range.length == 0 && rangeh.length == 0){
        
        string = [@"http://www." stringByAppendingString:str];
        
    } else if (rangeh.length > 0 && range.length == 0) {
        NSString * subString = [str substringFromIndex:rangeh.location+rangeh.length];
        string = [@"http://www." stringByAppendingString:subString];
    }
    else {
        string = str;
    }
    
    NSRange rangCom = [string rangeOfString:@".com" options:NSCaseInsensitiveSearch];
    if (rangCom.length > 0) {
        //有.com
        NSLog(@"sss");
    } else {
        if ([string hasSuffix:@".co"]) {
            
            string = [string stringByAppendingString:@"m"];
            
        } else {
            NSLog(@"lll");
            if ([string hasSuffix:@".c"]) {
                string = [string stringByAppendingString:@"om"];
            }else {
                //判断末尾是否有点
                if ([string hasSuffix:@"."]) {
                    string = [string stringByAppendingString:@"com"];
                } else {
                    string = [string stringByAppendingString:@".com"];
                }
            }
            
        }
    }
    
    return string;
}

//把网址写入本地plist文件
- (void)writeURLStringToPlist:(NSMutableArray *)theArray
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:kUrlHistoryPlist];
    
    for (int i = 0; i < [theArray count]; i++) {
        NSString * str = [theArray objectAtIndex:i];
        if ([str isEqualToString:self.searchURLString]) {//比较是否相等
            [theArray removeObjectAtIndex:i]; //移除相等的元素
            break;
        }
    }
    
    [theArray insertObject:self.searchURLString atIndex:0];
    [theArray writeToFile:filePath atomically:YES];
    NSLog(@"write %@*** %@",self.searchURLString,theArray);
}

//获取当前时间
- (NSString *)getCurrentStringDate
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strDate = [formatter stringFromDate:date];
    NSLog(@"%@",strDate);
    [formatter release];
    return strDate;
    
}

- (void)hiddenTopAndBoottomToolBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8f];
        
    _theTopSearchToolBar.frame = kHiddenTopToolBar;
    _theBottomToolBar.frame = kHiddenBottomToolBar;
    self.frame = CGRectMake(0, 0, 320, 460);
    [UIView commitAnimations];
    
    
}

- (void)showTopAndBoottomToolBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8f];

    _theTopSearchToolBar.frame = kShowTopToolBar;
    _theBottomToolBar.frame = kShowBottomToolBar;
    self.frame = CGRectMake(0, 44, 320, 460-88);
    [UIView commitAnimations];
    
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.request) {
        return;
    }
    
    if (scrollView.contentOffset.y > 150) {
        _imgV.hidden = NO;
        _imgV.highlighted = NO;
    }else {
        _imgV.hidden = YES;
    }
    
    if (scrollView.contentOffset.y < 100) { //显示
        
        if (!_isShowToolBar) {
            [self showTopAndBoottomToolBar];
            _isShowToolBar = !_isShowToolBar;
        }
        
    } else { //隐藏
        
        if (_isShowToolBar) {
            [self hiddenTopAndBoottomToolBar];
            _isShowToolBar = !_isShowToolBar;
        }
        
    }
}

#pragma mark - CutScreenshot
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    if (CGRectContainsPoint(_imgV.frame, point)) {
//        _imgV.highlighted = YES;
//    }
//    
//}

- (void)goScrollToTopDown:(UIButton *)sender
{
    _imgV.highlighted = YES;
}

- (void)goScrollToTop:(UIButton *)sender
{
    self.scrollView.contentOffset = CGPointMake(0, 0);
    _imgV.highlighted = NO;
}

@end
