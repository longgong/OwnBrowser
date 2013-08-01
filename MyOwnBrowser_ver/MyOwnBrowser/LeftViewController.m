//
//  LeftViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-24.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "LeftViewController.h"
#import "HistoryAndBookmarkViewController.h"
#import "Singleton.h"
#import "NavigationButton.h"
#import "MyWebView.h"
#import "IconNavigation.h"
#import "Singleton.h"
#import "MyNavigationViewController.h"
#import "SetupViewController.h"
#import "PresentView.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)dealloc
{
    [_aTableView release];
    [_aScrollView release];
    [_iconDatas release];
    NSLog(@"lefeView dealloc");
    [super dealloc];
}

- (void)prepareLoadUI
{
    _aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 460-44*3, 320, 44*3) style:UITableViewStylePlain];
    _aTableView.dataSource = self;
    _aTableView.delegate  = self;
    [self.view addSubview:_aTableView];
    
    _aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, 250, 460-80-132)];
    _aScrollView.bounces = NO;
    [self.view addSubview:_aScrollView];

}

- (void)prepareDatas
{
    if ([[IconNavigation findAllIconInfos] count] == 0) {
        [self prepareOriginalIconsArray];
    } else {
        self.iconDatas = [IconNavigation findAllIconInfos]; //数据库中查询所有图标信息
    }
    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path2 = [docPath stringByAppendingPathComponent:@"navigationBtnIcon"];
    
    NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString * originalPath = [bundlePath stringByAppendingPathComponent:@"navigationBtnIcon"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path2]) {
        
        if (![fileManager copyItemAtPath:originalPath toPath:path2 error:nil]) {
            NSLog(@"copy error");
        }
        
    }
    
    _iconRowWidth = 10;
    _iconColumnHeight = 0;
    for (int i = 0; i < (int)ceilf([self.iconDatas count]/3.0); i++) {
        _iconRowWidth = 10;
        
        BOOL out = NO;
        for (int j = 0; j < 3; j++) {
            if (i*3+j >= [self.iconDatas count]) {
                out = YES;
                break;
            }
            IconNavigation * icon = self.iconDatas[i*3+j];
            NavigationButton * nab = [[NavigationButton alloc] initWithFrame:CGRectMake(_iconRowWidth, _iconColumnHeight, 70, 70)];
            
            //            NSString * path = [[NSBundle mainBundle] pathForResource:icon.niIconString ofType:icon.niIconFormatter inDirectory:@"navigationBtnIcon"];
            
            NSString * path = nil;
            
            if (i*3+j > 4) {//
                
                path = [[NSString alloc] initWithFormat:@"%@/%@.%@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"navigationBtnIcon/loadImgIcon"],icon.niIconString,icon.niIconFormatter];//下载的图片保存在不同处
            } else {
                
                path = [[NSString alloc] initWithFormat:@"%@/%@.%@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"navigationBtnIcon"],icon.niIconString,icon.niIconFormatter];
                
            }
            
            
            UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];
            nab.img = img;
            nab.iconDelegate = self;
            nab.urlString = icon.niIconURL; //图标请求网址
            nab.titleLabel.text = icon.niTitle;
            [_aScrollView addSubview:nab];
            
            [img release];
            [nab release];
            [path release];
            _iconRowWidth += 80; //结束后 该值为下一个导航标签 水平坐标
            
        }
        
        if (out) {
            break;
        }
        _iconColumnHeight += 80; //结束后 该值为下一个导航标签 垂直坐标
    }
    
    [self insertAddNavigationIcon];
    [self adjustScrollViewContentSize];
}

- (void)adjustScrollViewContentSize
{
    int arrLen = [self.iconDatas count]+1;

    if ((int)ceilf(arrLen/3.0) >= 3) {
        
        self.aScrollView.contentSize = CGSizeMake(0, (ceilf(arrLen/3.0))*80-10);
        
    }

    
//    [self insertAddNavigationIcon];
}

- (void)insertAddNavigationIcon
{
    if (_iconRowWidth > 180) { //正好有3个倍数个导航标签时，不算添加标签
        _iconRowWidth = 10; //高度增加方法已走
    }
    
    NavigationButton * nab = [[NavigationButton alloc] initWithFrame:CGRectMake(_iconRowWidth, _iconColumnHeight, 70, 70)];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"add_nav_normal" ofType:@"png" inDirectory:@"navigationBtnIcon"];
    UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];
    nab.img = img;
    nab.iconDelegate = self;
    nab.titleLabel.text = @"添加导航";
    nab.tag = 111;
    [_aScrollView addSubview:nab];
    
    [img release];
    [nab release];
}

//从本地读取原始图片数据,并写入数据库
- (void)prepareOriginalIconsArray
{
    [IconNavigation addFirstIconWithURL:@"http://www.baidu.com" andIconString:@"baidu" andIconFormatter:@"png" andTitle:@"百度"];
    [IconNavigation addOneIconWithURL:@"http://www.hao123.com" andIconString:@"hao123" andIconFormatter:@"png" andTitle:@"好123"];
    [IconNavigation addOneIconWithURL:@"http://www.jd.com" andIconString:@"JD" andIconFormatter:@"png" andTitle:@"京东商城"];
    [IconNavigation addOneIconWithURL:@"http://www.renren.com" andIconString:@"renren" andIconFormatter:@"png" andTitle:@"人人网"];
    [IconNavigation addOneIconWithURL:@"http://www.tmall.com" andIconString:@"tmall" andIconFormatter:@"png" andTitle:@"天猫"];
    
    self.iconDatas = [IconNavigation findAllIconInfos];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
	// Do any additional setup after loading the view.
    
    [self prepareLoadUI];
    [self prepareDatas];
    Singleton * single = [Singleton shareSingleton];
    single.leftPageVC = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    Singleton * single = [Singleton shareSingleton];
    if (single.refreshUIDatas) {
        
        for (UIView * view in self.aScrollView.subviews) {
            [view removeFromSuperview];
        }
        [self prepareDatas];
        single.refreshUIDatas = NO;
    }
    
    if (single.isAddingFail) {
        
        PresentView * preView = [[PresentView alloc] initWithFrame:CGRectMake(65, -50, 120, 40)];
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        aLabel.numberOfLines = 2;
        aLabel.text = [NSString stringWithFormat:@"%@导航按钮已存在，不能重复添加",single.navigationIconName];
        aLabel.textColor = [UIColor yellowColor];
        preView.titleLabel = aLabel;
        [self.view addSubview:preView];
        
        [aLabel release];
        
        [UIView animateWithDuration:1.0f animations:^{
            preView.frame = CGRectMake(65, 20, preView.frame.size.width, preView.frame.size.height);
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(goRemovePreView:) userInfo:@{@"view":preView} repeats:NO];
        }];
        
        single.isAddingFail = NO;
        
    }
    
}

- (void)goRemovePreView:(NSNotification *)notification
{
    PresentView * view = [notification.userInfo objectForKey:@"view"];
    [view removeFromSuperview];
    [view release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelagate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"首页";
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"历史/书签";
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"设置";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self.revealSideViewController popViewControllerWithNewCenterController:[Singleton shareSingleton].homepageVC animated:YES];
    
    } else if(indexPath.row == 1) {
        
        HistoryAndBookmarkViewController * historyVC = [[HistoryAndBookmarkViewController alloc] init];        
        
        [self.revealSideViewController popViewControllerWithNewCenterController:historyVC animated:YES];
        
        [historyVC release];
    
    } else if(indexPath.row == 2) {
        
        SetupViewController * setupVC = [[SetupViewController alloc] init];
        Singleton * single = [Singleton shareSingleton];
        setupVC.accessingSwicthFlag = single.isSavingScanUrlHistroy;
        setupVC.accessingMusicSwicthFlag = single.isOpenPropmtMusic;
        
        
        UINavigationController * navigationVC = [[UINavigationController alloc] initWithRootViewController:setupVC];
        setupVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:navigationVC animated:YES completion:nil];
        [setupVC release];
        [navigationVC release];
    
    }
}

#pragma mark - NavigationIconProtocol实现
- (void)whenBeginClickButtonResponse:(NavigationButton *)sender
{
    
}

- (void)whenEndClickButtonResponse:(NavigationButton *)sender
{
    if (sender.tag == 111) { //添加导航
        MyNavigationViewController * myNaVC = [[MyNavigationViewController alloc] init];
        myNaVC.AddNavigation = sender;
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:myNaVC];
        [self presentViewController:naVC animated:YES completion:nil];
        [myNaVC release];
        [naVC release];
                
//        [IconNavigation addOneIconWithURL:@"http://www.hao123.com" andIconString:@"hao123" andIconFormatter:@"png" andTitle:@"好123"];
//        [self.iconDatas removeAllObjects];
//        self.iconDatas = [IconNavigation findAllIconInfos];
//        
//        NavigationButton * nab = [[NavigationButton alloc] initWithFrame:CGRectMake(_iconRowWidth, _iconColumnHeight, 70, 70)];
//        IconNavigation * lastIcon = [self.iconDatas lastObject];
//        
////        NSString * path = [[NSBundle mainBundle] pathForResource:lastIcon.niIconString ofType:lastIcon.niIconFormatter inDirectory:@"navigationBtnIcon"];
//        
//        NSString * path = [[NSString alloc] initWithFormat:@"%@/%@.%@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"navigationBtnIcon"],lastIcon.niIconString,lastIcon.niIconFormatter];
//        
//        UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];
//        nab.img = img;
//        nab.urlString = lastIcon.niIconURL;
//        nab.iconDelegate = self;
//        nab.titleLabel.text = lastIcon.niTitle;
//        [_aScrollView addSubview:nab];
//        
//        [img release];
//        [nab release];
//        
//        if (_iconRowWidth > 140) {
//            NSLog(@"huanhang");
//            _iconRowWidth = 10;
//            _iconColumnHeight += 80;
//        } else {
//            _iconRowWidth += 80;
//        }
//        
//        sender.frame = CGRectMake(_iconRowWidth, _iconColumnHeight, 70, 70);
//        
//        [self adjustScrollViewContentSize];
    } else {
    
        Singleton * single = [Singleton shareSingleton];
        
        [self.aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sender.urlString]]]; //请求网址
        
        [self.revealSideViewController popViewControllerWithNewCenterController:single.homepageVC animated:YES];
        
    }
    
    
}

@end
