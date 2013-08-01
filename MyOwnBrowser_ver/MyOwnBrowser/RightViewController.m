//
//  RightViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "RightViewController.h"
#import "NewPage.h"
#import "Singleton.h"
#import "MyWebView.h"
#import "ZoomImageView.h"

@interface RightViewController ()
{
    BOOL firstCreat;
}
@end

@implementation RightViewController

- (void)dealloc
{
    NSLog(@"rightView dealloc");
    [_aScrollView release];
    [_allPages release];
    [_allImageViews release];
    [super dealloc];
}

- (void)prepareRightUI
{
    
    self.allPages = [NewPage findAllPages]; //从数据库中取出所有窗口记录，按照窗口编号升序放入数组中
    _allImageViews = [[NSMutableArray alloc] init];
    _aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(95, 80, 200, 380)];
    _aScrollView.backgroundColor = [UIColor darkGrayColor];
    _aScrollView.clipsToBounds = NO;
    
    
    
    if ([self.allPages count] == 0) { //没有记录
        [self addEmptyPage:CGRectMake(0, 0, 200, 300)]; //该方法不会走
    } else {
        
        if ([self.allPages count] > 1) {
            
            _aScrollView.contentSize = CGSizeMake(_aScrollView.contentSize.width, [self.allPages count] * 320-20);
            _aScrollView.contentOffset = CGPointMake(0, ([self.allPages count] - self.currentWindowNumber)*320);
            
        } 
        
        for (int i = [self.allPages count]-1; i >= 0; i--) {
            NewPage * newpage = [self.allPages objectAtIndex:i];
            NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"windowPage"]; //临时文件夹路径
            NSString * filePath = [path stringByAppendingPathComponent:newpage.npFileName]; //获得文件存储路径
            [self addNewPage:CGRectMake(0, ([self.allPages count]-1-i)*320, 200, 300) filePath:filePath andNewPage:newpage];//创建imageView
        }
    }
    
    
    
    [self.view addSubview:_aScrollView];
    
    
    UISwipeGestureRecognizer * creatSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(createNewPage:)];
    creatSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_aScrollView addGestureRecognizer:creatSwipe];
    [creatSwipe release];
    
    UISwipeGestureRecognizer * deleteSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteOnePage:)];
    deleteSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [_aScrollView addGestureRecognizer:deleteSwipe];
    [deleteSwipe release];
    
    //覆盖背景
    UIImageView * aImgV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 0, 210, 80)];
    aImgV.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:aImgV];
    
    UILabel * stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 200, 40)];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.numberOfLines = 3;
    stateLabel.text = @"左扫新建窗口，右扫删除窗口，点击进入指定页.";
    stateLabel.backgroundColor = [UIColor clearColor];
    [aImgV addSubview:stateLabel];
    [stateLabel release];
    
    [aImgV release];
    
}

- (void)addEmptyPage:(CGRect)frame
{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = [UIImage imageNamed:@"newpage.png"];
    [_aScrollView addSubview:imgView];
    [self.allImageViews addObject:imgView];
    [imgView release];
}

- (void)addNewPage:(CGRect)frame filePath:(NSString *)filePath andNewPage:(NewPage *)newpage
{
    ZoomImageView * imgView = [[ZoomImageView alloc] initWithFrame:frame];
    UIImage * img = [[UIImage alloc] initWithContentsOfFile:filePath];
    imgView.image = img;
    [_aScrollView addSubview:imgView];
    
    imgView.urlString = newpage.npUrlString;
    imgView.windowNumber = newpage.npWindowNum;
    imgView.forwardDelegate = self;
    imgView.windowName = [NSString stringWithFormat:@"窗%d",newpage.npWindowNum];
    
    [self.allImageViews addObject:imgView]; //添加到数据库中,最先添入的时顶部窗口，即大序号窗口
    NSLog(@"V %@",imgView);
    [imgView release];
    [img release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
	// Do any additional setup after loading the view.
    
    [self prepareRightUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UISwipeGesture
- (void)createNewPage:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"create");
    //创建
    if ([self.allImageViews count] == 1) {
        
        _aScrollView.contentSize = CGSizeMake(_aScrollView.contentSize.width, 620);
        
    } else {//>1
        
        _aScrollView.contentSize = CGSizeMake(_aScrollView.contentSize.width, _aScrollView.contentSize.height+320);
        
    }
    
    ZoomImageView * imgView = [[ZoomImageView alloc] initWithFrame:CGRectMake(225, 0, 200, 300)];
    imgView.image = [[[UIImage alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"defaultPage.png"]] autorelease]; //空白页
    
    [_aScrollView addSubview:imgView];
    
    int count = [NewPage findAllWindowRows];
    NSString * imgName = [NSString stringWithFormat:@"window%d.png",count+1]; //代表新窗口名字
    NSData * imgData = UIImagePNGRepresentation(imgView.image);
    [imgData writeToFile:[[NSTemporaryDirectory() stringByAppendingString:@"windowPage"] stringByAppendingPathComponent:imgName] atomically:YES]; //写入临时文件夹
    imgView.urlString = [self readDefaultWebSiteFromPlist];
    imgView.windowNumber = count+1;
    imgView.windowName = [NSString stringWithFormat:@"窗%d",count+1];
    imgView.forwardDelegate = self; //设置代理
    
    [NewPage addNewPageWithURLString:[self readDefaultWebSiteFromPlist] andTime:[self getCurrentStringDate] andFileName:imgName andWindowNum:count+1]; //写入数据库，添加窗口
    
    [UIView animateWithDuration:0.5f animations:^{
        
        for (UIImageView * imgV in self.allImageViews) {
            //修改scrollView的frame
            imgV.frame = CGRectMake(0, imgV.frame.origin.y+320, 200, 300);
        }
        
    } completion:^(BOOL finished) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4f];
        imgView.frame = CGRectMake(0, 0, 200, 300);
        [UIView commitAnimations];
        
        
//        [self.allImageViews addObject:imgView];
        [self.allImageViews insertObject:imgView atIndex:0];
        [imgView release];
        _aScrollView.contentOffset = CGPointMake(0, 0);
    }];
    
}

- (NSString *)readDefaultWebSiteFromPlist
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"defaultWebsite.plist"];
    NSString * urlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return [urlString autorelease];
}

- (void)deleteOnePage:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"删除旧窗口");
    
    [UIView animateWithDuration:0.4f animations:^{
        
        ZoomImageView * imgV = [self.allImageViews objectAtIndex:0];//数组中最少会有一个元素
        imgV.transform = CGAffineTransformMakeScale(225, 0);
        [NewPage deleteOnePageByWindowNum:imgV.windowNumber]; //删除数据库文件
        NSLog(@"num = %d",imgV.windowNumber);
        
        NSString * removePath = [NSTemporaryDirectory() stringByAppendingFormat:@"windowPage/window%d.png",imgV.windowNumber]; //删除图片的路径
        [self removeFileByFilePath:removePath];//删除图片文件
        [self.allImageViews removeObjectAtIndex:0];//删除指定元素
    
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            NSLog(@"allViews = %@",self.allImageViews);
            for (UIImageView * imgView in self.allImageViews) {//坐标上移
                NSLog(@"kk");
                imgView.frame = CGRectMake(0, imgView.frame.origin.y-320, 200, 300);
   
            }
        } completion:^(BOOL finished) {
            if([self.allImageViews count] == 0) { //先删除 再加载空白页，此处代表窗口已经全部删除，需重新再创建一个
                
                ZoomImageView * imgView = [[ZoomImageView alloc] initWithFrame:CGRectMake(225, 0, 200, 300)];
                imgView.image = [[[UIImage alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"defaultPage.png"]] autorelease]; //加载默认网页
                [_aScrollView addSubview:imgView];
                
                imgView.windowNumber = 1;
                imgView.urlString = [self readDefaultWebSiteFromPlist]; //读取默认网址
                imgView.forwardDelegate = self;
                imgView.windowName = @"窗1";
                
                //写入数据库
                [NewPage addNewPageWithURLString:imgView.urlString andTime:[self getCurrentStringDate] andFileName:[NSString stringWithFormat:@"window%d.png",imgView.windowNumber]];
                //写入临时文件
                NSData * imgData = UIImagePNGRepresentation(imgView.image);
                [imgData writeToFile:[[NSTemporaryDirectory() stringByAppendingString:@"windowPage"] stringByAppendingPathComponent:[NSString stringWithFormat:@"window%d.png",imgView.windowNumber]] atomically:YES]; //写入临时文件夹
                
                [UIView animateWithDuration:0.3f animations:^{
                    imgView.frame = CGRectMake(0, 0, 200, 300);
                }];
                
                [self.allImageViews addObject:imgView];
                
                [imgView release];
                
            }
        }];
    }];
    
    if ([self.allImageViews count] == 1) {
        
        _aScrollView.contentSize = CGSizeMake(_aScrollView.contentSize.width, 380);
       
    } else {
        
        _aScrollView.contentSize = CGSizeMake(_aScrollView.contentSize.width, _aScrollView.contentSize.height-320);
        
    }

    

}

- (void)removeFileByFilePath:(NSString *)filePath
{
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSError * error = nil;
        if ([fm isDeletableFileAtPath:filePath]) {
            BOOL success = [fm removeItemAtPath:filePath error:&error];
            if (!success) {
                NSLog(@"删除错误 %@",[error localizedDescription]);
            }
        } else {
            NSLog(@"不能删除");
        }
    }
}

#pragma mark - loadWebPageProtocol
- (void)goBackToLoadNewPage:(ZoomImageView *)imgView
{
    NSLog(@"ttt");
    Singleton * single = [Singleton shareSingleton];
    [single.homepageVC.aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgView.urlString]]];
    single.homepageVC.windowNumber = imgView.windowNumber; //获取窗口编号
    
    [self.revealSideViewController popViewControllerAnimated:YES];
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
@end
