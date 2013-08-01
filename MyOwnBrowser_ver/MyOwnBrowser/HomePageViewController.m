//
//  HomePageViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "HomePageViewController.h"
#import "MySearchToolBar.h"
#import "MyItemToolBar.h"
#import "MyWebView.h"
#import "HistoryWebsite.h"
#import "KeyWordSearch.h"
#import "ScanURLHistory.h"
#import "Bookmark.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "LeftViewController.h"
#import "RightViewController.h"
#import "Singleton.h"
#import "AlertMusicPlayer.h"

#import "NewPage.h"

#define kInputWebsiteNotification @"inputWebsite"

@interface HomePageViewController ()
{
    BOOL isInputURL; //判断是否是输入的网址
}
@end

@implementation HomePageViewController

- (void)dealloc
{
    [_topSearchToolBar release];
    [_bottomToolBar release];
    [_resultURLDatas release];
    [_resultKeywordDatas release];
    [_resultDatas release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputWebsiteNotification object:nil];
    NSLog(@"homepage dealloc");
    NSLog(@"shifang");
    [NewPage deleteAllPages];
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"windowPage"];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    //加载UI控件准备函数
    [self prepareUIControl];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    [super viewWillAppear:animated];
//    
//    LeftViewController * leftVC = [[LeftViewController alloc] init];
//    leftVC.aWebView = self.aWebView;
//    [self.revealSideViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
//    [leftVC release];
//    
//    RightViewController * rightVC = [[RightViewController alloc] init];
//    [self.revealSideViewController preloadViewController:rightVC forSide:PPRevealSideDirectionRight];
//    [rightVC release];
//    
//}

#pragma mark - 初始化UI控件准备工作
//初始化UI控件准备工作
- (void)prepareUIControl
{
    //加载显示网页控件
    self.defaultURLString = @"http://www.baidu.com";
    NSString * aStr = [self readDefaultWebSiteFromPlist];
    if (aStr) { //有值存在
        self.defaultURLString = aStr;
    }else {
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * filePath = [docPath stringByAppendingPathComponent:@"defaultWebsite.plist"];
        [self.defaultURLString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]; //网址写入本地
        
        //设置成功截取缩略图,并存入documents文件夹
        NSData * defaultImgData = UIImagePNGRepresentation([UIImage imageNamed:@"defaultPage.png"]);
        [defaultImgData writeToFile:[docPath stringByAppendingPathComponent:@"defaultPage.png"] atomically:YES]; //写入文件
        Singleton * singe = [Singleton shareSingleton];
        singe.defaultPage = [[NewPage alloc] init];
        singe.defaultPage.npUrlString = self.defaultURLString; //存取默认网址
    }
    
    _aWebView = [[MyWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-88)];
    _aWebView.delegate = self;
    [_aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.defaultURLString]]];
    [self.view addSubview:_aWebView];
    
    //加载顶部工具条
    _topSearchToolBar = [[MySearchToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _topSearchToolBar.rootViewController = self; //传值，传递根视图
    [self.view addSubview:_topSearchToolBar];
    
    //加载底部工具条
    _bottomToolBar = [[MyItemToolBar alloc] initWithFrame:CGRectMake(0, 460-44, 320, 44)];
    _bottomToolBar.webView = _aWebView;
    _bottomToolBar.ownDelegate = self;
    [self.view addSubview:_bottomToolBar];
    
    _aWebView.theTopSearchToolBar = _topSearchToolBar;
    _aWebView.theBottomToolBar = _bottomToolBar;
    _windowNumber = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInputStatus) name:kInputWebsiteNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    Singleton * single = [Singleton shareSingleton];
    single.homepageVC = self;
    _windowNumber = 1; //默认显示第一个窗口
    single.isSavingScanUrlHistroy = YES; //默认开启保存浏览历史记录
    single.isOpenPropmtMusic = NO;//默认关闭提示音
    
//    self.revealSideViewController.panInteractionsWhenClosed = PPRevealSideInteractionContentView;
    [self creatMusic];
}


- (void)creatMusic
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    player.numberOfLoops = 1;
    player.volume = 1.0f;
    
    AlertMusicPlayer * alertMP = [AlertMusicPlayer defaultAlertMusicPlayer];
    alertMP.alertPalyer = player;
    [player release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * currentTime = [self getCurrentStringDate];
    if ([searchBar isEqual:self.topSearchToolBar.urlSearchBar]) { //点击的是搜索网址
        
        [self.aWebView loadUrlWebSite:searchBar.text];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInputWebsiteNotification object:self userInfo:nil];
        
        [self.topSearchToolBar.urlSearchController setActive:NO animated:YES];
        
    } else { //点击的是搜索关键字
        
        
        [KeyWordSearch addKeyWordResultWithKeyword:searchBar.text andTime:currentTime andSearchEngine:@"以后添加"];
        [self.topSearchToolBar.keywordSearchController setActive:NO animated:YES];
    }
    
}

#pragma mark - 通知
- (void)changeInputStatus
{
    isInputURL = YES; //是输入的网址，并点击了搜索
}

#pragma mark - UISearchDispalyDelegate
//搜索视图控制器将要开始编辑时
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self.topSearchToolBar mySearchBarWillBeginSearch:controller];
    _resultDatas = [[NSMutableArray alloc] init];
    
}

//搜索视图控制器已经开始编辑时
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.topSearchToolBar mySearchBarDidBeginSearch:controller];
    
}

//搜索视图控制器将要结束编辑时
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.topSearchToolBar mySearchBarWillEndSearch:controller];
}

//搜索视图控制器已经结束编辑时,search按钮方法要比该方法先执行
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.topSearchToolBar mySearchBarDidEndSearch:controller];
    [self.resultDatas removeAllObjects];
    self.resultDatas = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.resultDatas removeAllObjects];    
    if ([controller isEqual:self.topSearchToolBar.urlSearchController]) { //响应网址搜索视图控制器
        
        self.resultDatas = [HistoryWebsite selectHistoryResultsWithLikeUrlString:searchString];
        
    } else {
        
        self.resultDatas = [KeyWordSearch selectKeywordResultsWithLikeKeyword:searchString];
                
    }
    return YES;
}

#pragma mark - 查找匹配算法
/*
//匹配插入算法,按关键字匹配
- (void)matchStringWithSearchString:(NSString *)theStr
{
    [self.resultKeywordDatas removeAllObjects];
    NSArray * stringArray = [theStr componentsSeparatedByString:@" "];
    
    for (int i = 0; i < [self.resultDatas count]; i++) {
        KeyWordSearch * keyword = [self.resultDatas objectAtIndex:i];
        
        for (NSString * aSeparatedStr in stringArray) {
            
            NSRange range = [keyword.kword rangeOfString:theStr];
            if (range.length > 0) { //> 则代表有相同的关键字
                [self.resultKeywordDatas addObject:keyword];
            }
        }

        
//        if (range.length > 0) { //> 则代表有相同的关键字
//            
//            [self.resultKeywordDatas addObject:keyword];
//            
//        }
    }
    
}

//搜索算法，匹配网址
- (void)fitWithURLString:(NSString *)theURLString
{
    
    [self.resultURLDatas removeAllObjects]; //把上一次表中存储的数据清空
    
    for (int i = 0 ; i < [self.resultDatas count]; i++) {
        
        HistoryWebsite * historyWebsite = [self.resultDatas objectAtIndex:i];
        
        if ([self formatterStringFromUrlString:theURLString byString:historyWebsite.htURL]) {
            
            [self.resultURLDatas addObject:historyWebsite];
            
        }
        
    }

}

//判断输入的网址,是怎样格式的,相等返回yes
- (BOOL)formatterStringFromUrlString:(NSString *)str byString:(NSString *)baseString
{ //http://www
    NSString * string = nil;
    int len = [str length]; //输入字符串长度
    BOOL isSame = NO;
    NSComparisonResult result;
    
    if (len < 4) {
        
        NSRange range = [baseString rangeOfString:str];
        if (range.length > 0) { //有查到相同的
            isSame = YES;
        }
        
    } else if (len <= 7) {
        NSString * subStr = [[str substringToIndex:4] lowercaseString]; //转化成小写的子串
        
        if ([subStr hasPrefix:@"www."]) { //是否有该前缀，YES
            
            string = [@"http://" stringByAppendingString:str];
            result = [baseString compare:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
            if (result == NSOrderedSame) { //找到相同的
                isSame = YES;
            }
            
        } else if ([subStr hasPrefix:@"http"]) {
            
            NSRange range = [baseString rangeOfString:str];
            if (range.length > 0) { //有查到相同的
                isSame = YES;
            }
            
        } else {
            
            string = [self judgeUrlString:str];
            result = [baseString compare:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
            if (result == NSOrderedSame) { //找到相同的
                isSame = YES;
            }
            
        }
    } else if (len <= 11){
        
        NSString * subStr = [[str substringToIndex:8] lowercaseString]; //转化成小写的子串
        NSString * subSring = [[str substringToIndex:4] lowercaseString];
        if ([subStr hasPrefix:@"http://w"]) {
            result = [baseString compare:str options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
            if (result == NSOrderedSame) { //找到相同的
                isSame = YES;
            }
        } else if ([subSring hasPrefix:@"www."]) {
            
            string = [@"http://" stringByAppendingString:str];
            result = [baseString compare:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
            if (result == NSOrderedSame) { //找到相同的
                isSame = YES;
            }
            
        } else {
            
            string = [self judgeUrlString:str];
            result = [baseString compare:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
            if (result == NSOrderedSame) { //找到相同的
                isSame = YES;
            }
        
        }
        
    } else {
    
        string = [self judgeUrlString:str];
        result = [baseString compare:string options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        if (result == NSOrderedSame) { //找到相同的
            isSame = YES;
        }
        
    }
    
    
    return isSame;
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
    
    return string;
}
*/
 
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.aWebView openIndicatorView]; //打开活动指示器
    NSLog(@"start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.aWebView closeIndicatorView]; //关闭活动指示器
    
//    NSString * currentURL = [self.aWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString * title = [self.aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString * urlString = [[webView.request URL] absoluteString];

    Singleton * single = [Singleton shareSingleton];
    if (single.isSavingScanUrlHistroy) {//值为真 才保存浏览历史记录
        [ScanURLHistory addScanHistoryURL:urlString andTime:[self getCurrentStringDate] andScanTitle:title];
    }
    
    NSLog(@"url = %@,finish,title = %@ ",urlString,title);
    if (isInputURL) { //在输入框中输入的网址，则把标题写入
        [HistoryWebsite updateTitle:title byURLString:self.aWebView.searchURLString];
        isInputURL = NO;
    } else {
        NSArray * strArr = [urlString componentsSeparatedByString:@"."];
        NSString * likeStr = nil;
        
        if ([strArr count] <= 2) {
            likeStr = [[(NSString *)strArr[0] componentsSeparatedByString:@"//"] objectAtIndex:1];
        } else {
            likeStr = [strArr[1] stringByAppendingFormat:@".%@",strArr[2]];
        }
        
        NSString * theUrlStr = [HistoryWebsite findUrlStringByLikeString:likeStr];
        if (theUrlStr) {
            [HistoryWebsite updateTitle:title byURLString:theUrlStr];
        }
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"loda web fail"); //停止网页会走该方法,并且不会加载任何东西
    [self.aWebView closeIndicatorView]; //关闭活动指示器
    isInputURL = NO;
}

//该代理方法是四个代理方法中最先运行的
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
/*
//    NSURL * url = [request URL];
//    BOOL isSuccess = [[UIApplication sharedApplication] canOpenURL:url];
//    if (isSuccess) {
//        NSLog(@"open success");
//    } else {
//        NSLog(@"open error");
//    }
    
//    if (navigationType == UIWebViewNavigationTypeBackForward) {
//        NSLog(@"后退前进");
//    } else if(navigationType == UIWebViewNavigationTypeLinkClicked) {
//        NSLog(@"单击");
//    } else if(navigationType == UIWebViewNavigationTypeReload) {
//        NSLog(@"重新加载");
//    } else if(navigationType == UIWebViewNavigationTypeOther) {
//        NSLog(@"其他");
//    } else if(navigationType == UIWebViewNavigationTypeFormSubmitted) {
//        NSLog(@"提交");
//    } else if(navigationType == UIWebViewNavigationTypeFormResubmitted) {
//        NSLog(@"提交2");
//    }
*/
   if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSLog(@"jiazai");
//        [ScanURLHistory addScanHistoryURL:[[webView.request URL] absoluteString] andTime:[self getCurrentStringDate] andScanTitle:nil];

    }
    
    return YES;
}

#pragma mark- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
    }
    
    id obj = self.resultDatas[0];
    if ([obj isKindOfClass:[HistoryWebsite class]]) {
        
        HistoryWebsite * historyWebsite = self.resultDatas[indexPath.row];
        cell.detailTextLabel.text = historyWebsite.htURL;
        cell.textLabel.text = historyWebsite.htTitle;
        
    } else if([obj isKindOfClass:[KeyWordSearch class]] ) {

        KeyWordSearch * historyWebsite = self.resultDatas[indexPath.row];
        cell.detailTextLabel.text = historyWebsite.kword;
        
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.resultDatas count];
}

//选中某一行的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * theTime = [self getCurrentStringDate];
    
    if ([self.topSearchToolBar.urlSearchController.searchResultsTableView isEqual:tableView]) {
        
        NSString * urlString = cell.detailTextLabel.text;
        [HistoryWebsite addHistoryWebsiteWithURL:urlString andTime:theTime andTitle:nil];
        [self.aWebView loadUrlWebSite:urlString];
        isInputURL = NO;
        
    } else {

        KeyWordSearch * keyword = self.resultDatas[indexPath.row];
        [KeyWordSearch addKeyWordResultWithKeyword:keyword.kword andTime:theTime andSearchEngine:nil];
        
    }
    
    [self.topSearchToolBar setActiveWithUrlSearchCtrlandKeywordSearchCtrl:NO];
    
}

#pragma mark - readPlistFile
- (void)readUrlStringFromPlist
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"urlHistory.plist"];
    
    _resultURLDatas = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
}

- (NSString *)readDefaultWebSiteFromPlist
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [docPath stringByAppendingPathComponent:@"defaultWebsite.plist"];
    NSString * urlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return [urlString autorelease];
}

#pragma mark - DoLeftOrRightProtocol
- (void)pushLeftViewController
{
//    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
    
    LeftViewController * leftVC = [[LeftViewController alloc] init];
    leftVC.aWebView = self.aWebView;
    [self.revealSideViewController pushViewController:leftVC onDirection:PPRevealSideDirectionLeft animated:YES];
    [leftVC release];
    
}

- (void)pushRightViewController
{
//    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
    
    RightViewController * rightVC = [[RightViewController alloc] init];
    rightVC.currentWindowNumber = self.windowNumber; //属性传值，存储当前窗口
    //把截图写入数据库
    
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"windowPage"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imgName = [NSString stringWithFormat:@"window%d.png",self.windowNumber];
    UIImage * currentImg = [self screenShot:self.aWebView.frame.size andView:self.aWebView];
    NSData * imgData = UIImagePNGRepresentation(currentImg);
    [imgData writeToFile:[path stringByAppendingPathComponent:imgName] atomically:YES];//把图片数据临时写入本地
    

    //根据窗口编号写入对应文件
    if (self.windowNumber == 1) { //判断窗口序号
        //本地加载
        
        if ([NewPage findAllWindowRows] == 0) { //判断数据库中是否有该窗口,没有则创建
            
            [NewPage addNewPageWithURLString:[self.aWebView.request.URL absoluteString] andTime:[self getCurrentStringDate] andFileName:imgName];
            
        } else {
            
            [NewPage updatePageUrlString:[self.aWebView.request.URL absoluteString] andTime:[self getCurrentStringDate] ByWindowNum:self.windowNumber]; //窗口存在更新
            
        }
        
    } else {
        
        [NewPage updatePageUrlString:[self.aWebView.request.URL absoluteString] andTime:[self getCurrentStringDate] ByWindowNum:self.windowNumber]; //窗口存在更新
         
    }
    

    
    [self.revealSideViewController pushViewController:rightVC onDirection:PPRevealSideDirectionRight animated:YES];
    [rightVC release];
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


//设置书签代理方法
- (void)recordBookmark
{
    NSString * currentURL = [[self.aWebView.request URL] absoluteString];
    
    if([currentURL isEqualToString:@""] || !currentURL) {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"设置书签" message:@"当前网页为空不能设置书签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertview show];
        [alertview release];
    } else {
        
        int num = [Bookmark findOneBookmarkByURL:currentURL]; //0代表该网页未设置成书签，1则已设置
        
        if (!num) {
            
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"设置书签" message:@"点添加书签把当前页面设置为书签,不设置点取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加书签", nil];
            alertview.tag = 1000;
            [alertview show];
            [alertview release];
            
        } else {
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"删除书签" message:@"点删除书签把当前书签删除,不设置点取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除书签", nil];
            alertview.tag = 1001;
            [alertview show];
            [alertview release];
        }
    }
}

#pragma mark - UIAlertViewDelagate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int  value = buttonIndex;
    switch (value) {
        case 0:{
            
            break;
        }
        case 1:{
            
            NSString * currentURL = [[self.aWebView.request URL] absoluteString];
            if (alertView.tag == 1000) {
                
                ScanURLHistory * scanURl = [ScanURLHistory findOneScanUrlHistoryResultByUrl:currentURL]; //获取标题
                [Bookmark addBookmarkWithURL:currentURL andTime:[self getCurrentStringDate] andTitle:scanURl.swTitle];
                
            } else {
                
                [Bookmark deleteOneBookmarkByURL:currentURL]; //删除书签
                
            }
            
            break;
        }
        default:
            break;
    }
}


@end
