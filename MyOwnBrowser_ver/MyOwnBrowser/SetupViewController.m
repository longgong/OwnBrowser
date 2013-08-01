//
//  SetupViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-6.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "SetupViewController.h"
#import "HistoryWebsite.h"
#import "KeyWordSearch.h"
#import "ScanURLHistory.h"
#import "IconNavigation.h"
#import "LeftViewController.h"
#import "Singleton.h"
#import "AlertMusicPlayer.h"
#import "Bookmark.h"
#import "MyWebView.h"

@interface SetupViewController ()
{
    BOOL clearResults[5]; //清楚历史标志，Yes代表清除，NO代表不清除，下标分别对应 @"清除输入历史",@"清除搜索历史",@"清除访问历史",@"清除导航按钮",@"恢复默认设置"
    UISwitch * accessSwitch;//设置访问历史选择器
    UISwitch * musicSwitch;//设置音乐开关选择器

}
@end

@implementation SetupViewController

- (void)dealloc
{
    [_aTableView release];
    [_setupDatas release];
    [accessSwitch release];
    [musicSwitch release];
    NSLog(@"setupVC dealloc");
    [super dealloc];
}

- (void)prepareSetupUI
{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(goDoneAction:)];
    backItem.tag = 201;
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goDoneAction:)];
    doneItem.tag = 202;
    self.navigationItem.rightBarButtonItem = doneItem;
    [doneItem release];
    
    
    _aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44) style:UITableViewStyleGrouped];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView];
    
    
}

- (void)prepareDataSource
{
    NSArray * arr1 = [[NSArray alloc] initWithObjects:@"清除输入历史",@"清除搜索历史",@"清除访问历史",@"清除导航按钮",@"恢复默认设置", nil];
    NSArray * arr2 = [[NSArray alloc] initWithObjects:@"保存访问历史",@"开启提示音",nil];
    NSArray * arr3 = [[NSArray alloc] initWithObjects:@"主题选择", nil];
    _setupDatas = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3, nil];
    [arr1 release];
    [arr2 release];
    [arr3 release];
    for (int i = 0; i < 5; i++) {
        clearResults[i] = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的设置";
	// Do any additional setup after loading the view.
    
    [self prepareDataSource];
    [self prepareSetupUI]; //加载UI界面
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DoneAction
//响应导航Item动作
- (void)goDoneAction:(UIBarButtonItem *)sender
{
    if (sender.tag == 201) { //back按钮

        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else { //done按钮
        
        if(clearResults[4]) { //恢复默认设置
            
            [self recoverDefaultSeting];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        [self deleteRelativeRusults]; //执行section0相关操作
        
        [self designAccessAndMusic];
        
        
        
        
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)recoverDefaultSeting
{
    Singleton * single = [Singleton shareSingleton];
    
    [HistoryWebsite deleteAllHistoryWebsiteResults];
    
    [KeyWordSearch deleteAllKeywordResults];
    
    [ScanURLHistory deleteAllScanUrlResults];
    
    [IconNavigation deleteAllLoadIconResultsByID:5];
    single.refreshUIDatas = YES;
    
    [Bookmark deleteAllBookmarkResults];

    //修改默认网址
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"defaultWebsite.plist"];
    [@"http://www.baidu.com" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]; //网址写入本地
    [single.homepageVC.aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    NSData * imgData = UIImagePNGRepresentation([UIImage imageNamed:@"defaultPage.png"]);
    
    //把默认图片存入documents文件夹
    [imgData writeToFile:[docPath stringByAppendingPathComponent:@"defaultPage.png"] atomically:YES]; //写入文件
    
    
    //打开访问历史
    single.isSavingScanUrlHistroy = YES;
    //关闭提示音
    single.isOpenPropmtMusic = NO;
    
    //关闭多个窗口
    single.homepageVC.windowNumber = 1;
    [NewPage deleteAllPages]; //删除数据库中所有窗口数据
    //删除窗口对应图片
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"windowPage"];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

//执行删除相关记录操作
- (void)deleteRelativeRusults
{
    if (clearResults[0]) { //清除输入历史
        [HistoryWebsite deleteAllHistoryWebsiteResults];
    }
    
    if(clearResults[1]) { //清除搜索历史
        [KeyWordSearch deleteAllKeywordResults];
    }
    
    if(clearResults[2]) { //清除访问历史
        [ScanURLHistory deleteAllScanUrlResults];
    }
    
    if(clearResults[3]) { //清除导航按钮
        [IconNavigation deleteAllLoadIconResultsByID:5];//删除下载的导航图标，即id>5的所有图标
        Singleton * single = [Singleton shareSingleton];
        single.refreshUIDatas = YES;
    }
    
    
}

- (void)designAccessAndMusic
{
    Singleton * single = [Singleton shareSingleton];
    if (accessSwitch.on) {
        single.isSavingScanUrlHistroy = YES;//开启保存浏览历史
    } else {
        single.isSavingScanUrlHistroy = NO;//关闭保存浏览历史
    }
    
    if (musicSwitch.on) {
        single.isOpenPropmtMusic = YES;//开启提示音
    } else {
        single.isOpenPropmtMusic = NO; //关闭提示音
    }

}

//响应选择开关动作
- (void)goSwitchAction:(UISwitch *)sender
{
    NSLog(@"switch");
    if (sender.tag == 1001) { //执行修改保存历史设置

        
    } else { //执行提示音设置
        
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {//保存访问历史,默认保存
            
            accessSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
            accessSwitch.on  = _accessingSwicthFlag;
//            [accessSwitch addTarget:self action:@selector(goSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = accessSwitch;
            
            
        } else if (indexPath.row == 1) {//开启提示音
            
            musicSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
            musicSwitch.on  = _accessingMusicSwicthFlag;
//            [musicSwitch addTarget:self action:@selector(goSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = musicSwitch;
            
        }
        
    }
    
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = [self.setupDatas objectAtIndex:indexPath.section][indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.setupDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.setupDatas objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title = nil;
    switch (section) {
        case 0:{
            title = @"清除设置";
            break;
        }
        case 1:{
            title = @"高级设置";
            break;
        }
        case 2:{
            title = @"主题设置";
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"setup didselect");
    AlertMusicPlayer * alertMP = [AlertMusicPlayer defaultAlertMusicPlayer];
    
    if (indexPath.section == 0) {
        
        [alertMP automaticalJudgingPlay];
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        clearResults[indexPath.row] = !clearResults[indexPath.row];//改变状态
        if (clearResults[indexPath.row]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
    } else if (indexPath.section == 1) {
        
        
        
    } else {
        
        [alertMP automaticalJudgingPlay];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
