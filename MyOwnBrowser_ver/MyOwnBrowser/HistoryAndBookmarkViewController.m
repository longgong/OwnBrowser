//
//  HistoryAndBookmarkViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "HistoryAndBookmarkViewController.h"
#import "BottomBookMarkToolbar.h"
#import "ScanURLHistory.h"
#import "Bookmark.h"
#import "Singleton.h"
#import "MyWebView.h"
#import "BookmarkTableViewCell.h"
#import "HistoryURLTableViewCell.h"

#define kDeleteBookmarkNotification @"deleteBookmark"

#define kDeleteOneBookmarkNotification @"deleteOneBookmark"
#define kAddBookmarkNotification @"addBookmark"

@interface HistoryAndBookmarkViewController ()
{
    NSArray * headerStings; //存放表头标题
}
@end

@implementation HistoryAndBookmarkViewController

- (void)dealloc
{
    [_downToolbar release];
    self.aTableView = nil;
    self.historyResults = nil;
    self.resultArray = nil;
    NSLog(@"历史页面dealloc");
    [headerStings release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeleteBookmarkNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeleteOneBookmarkNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddBookmarkNotification object:nil];
    
    
    [super dealloc];
}

- (void)viewDidLoad
{
    NSLog(@"历史页面创建");
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    
    _downToolbar = [[BottomBookMarkToolbar alloc] initWithFrame:CGRectMake(0, 460-44, 320, 44)];
    _downToolbar.itemDelegate = self;
    [self.view addSubview:self.downToolbar];
    
    
    _aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44) style:UITableViewStylePlain];
    _aTableView.dataSource = self;
    _aTableView.delegate = self;
    [self.view addSubview:_aTableView];
    
    
    _historyResults = [[NSMutableArray alloc] init];
    headerStings = [[NSArray alloc] initWithObjects:@"今天",@"昨天",@"前天",@"更早", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBookmark:) name:kDeleteBookmarkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneBookmark:) name:kDeleteOneBookmarkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOneBookmark:) name:kAddBookmarkNotification object:nil];
    
//    [self readWithSectionsScanHistoryDatas];
    
    [self modifierHistoryResultDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HistoryAndBookmarkProtocol
- (void)showHistoryResult
{
    [self.resultArray removeAllObjects];
    
    [self modifierHistoryResultDatas]; //修改数据源信息
    [self.aTableView reloadData];
}

- (void)showBookmarkResult
{
    [self.historyResults removeAllObjects];
    
    self.resultArray = [Bookmark findAllBookmark];
    [self.aTableView reloadData];
}

- (void)goBackToLeft
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
    [self release];
    
}

- (void)forwardToRight
{
    
}

- (void)deleteBookmark:(NSNotification *)notification
{
    NSString * urlString = [notification.userInfo objectForKey:@"url"];
    [Bookmark deleteOneBookmarkByURL:urlString];
    [self showBookmarkResult];
}

//获取当前时间
- (NSString *)getCurrentStringDate
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strDate = [formatter stringFromDate:date];
    [formatter release];
    return strDate;
}



#pragma mark 修改数据源方法
- (void)modifierHistoryResultDatas
{
    self.resultArray = [ScanURLHistory findAllHistoryURL];
    
    NSMutableArray * arraySection0 = [[NSMutableArray alloc] init];
    NSMutableArray * arraySection1 = [[NSMutableArray alloc] init];
    NSMutableArray * arraySection2 = [[NSMutableArray alloc] init];
    NSMutableArray * arraySection3 = [[NSMutableArray alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * currentString = [self getCurrentStringDate]; //当前时间的字符串
//    NSDate * currentDate = [[NSDate alloc] initWithTimeInterval:8*60*60  sinceDate: [formatter dateFromString:currentString]]; //当前时间的日期
    
    
    NSString * todayStr = [[NSString alloc] initWithFormat:@"%@ 00:00:00",[currentString substringToIndex:10]];  //获取今天开始时日期
    NSDate * todayDate =  [[NSDate alloc] initWithTimeInterval:8*60*60  sinceDate: [formatter dateFromString:todayStr]];
    
    
    NSString * yesterdayStr = [formatter stringFromDate:[[[NSDate alloc] initWithTimeInterval:-32*60*60  sinceDate:todayDate] autorelease]];
    NSDate * yesterdayDate =  [[NSDate alloc] initWithTimeInterval:8*60*60  sinceDate: [formatter dateFromString:yesterdayStr]];  //获取昨天开始时日期
    
    NSString * beforeYesterdayStr = [formatter stringFromDate:[[[NSDate alloc] initWithTimeInterval:-56*60*60  sinceDate:todayDate] autorelease]];
    NSDate * beforeYesterdayDate =  [[NSDate alloc] initWithTimeInterval:8*60*60  sinceDate: [formatter dateFromString:beforeYesterdayStr]]; //获取前天开始时日期
    
    
    for (ScanURLHistory * scanURL in self.resultArray) {
        
        NSDate * date = [[NSDate alloc] initWithTimeInterval:8*60*60 sinceDate:[formatter dateFromString:scanURL.swScanTime]];
                
        if ([date compare:todayDate] == NSOrderedDescending) {
            
            [arraySection0 addObject:scanURL];
            
        } else if ([date compare:yesterdayDate] == NSOrderedDescending){
            
            [arraySection1 addObject:scanURL];
            
        } else if ([date compare:beforeYesterdayDate] == NSOrderedDescending){
            
            [arraySection2 addObject:scanURL];
            
        } else if ([date compare:beforeYesterdayDate] == NSOrderedAscending || [date compare:beforeYesterdayDate] == NSOrderedSame) {
            
            [arraySection3 addObject:scanURL];
            
        }
        [date release];
    }
    
    
    [self.historyResults addObject:arraySection0];
    [self.historyResults addObject:arraySection1];
    [self.historyResults addObject:arraySection2];
    [self.historyResults addObject:arraySection3];
    [arraySection0 release];
    [arraySection1 release];
    [arraySection2 release];
    [arraySection3 release];
    [formatter release];
    
    [todayDate release];
    [yesterdayDate release];
    [beforeYesterdayDate release];
}

//通过数据库读取带section的数据源
- (void)readWithSectionsScanHistoryDatas
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * currentDate = [NSDate date];
    NSDate * yesterdayDate = [[NSDate alloc] initWithTimeInterval:-24*60*60 sinceDate:currentDate];
    NSDate * boforeDate = [[NSDate alloc] initWithTimeInterval:-48*60*60 sinceDate:currentDate];
    
    NSString * currentLikeString = [[formatter stringFromDate:currentDate] substringToIndex:10];
    NSString * yesterdayLikeString = [[formatter stringFromDate:yesterdayDate] substringToIndex:10];
    NSString * beforeLikeString = [[formatter stringFromDate:boforeDate] substringToIndex:10];
    
    for (int i = 0; i < 4; i++) {
        NSMutableArray * array = nil;
        
        switch (i) {
            case 0:{
                array = [[ScanURLHistory findScanHistoryRecordsWithLikeTimeSearch:currentLikeString] retain];
                break;
            }
            case 1:{
                array = [[ScanURLHistory findScanHistoryRecordsWithLikeTimeSearch:yesterdayLikeString] retain];
                break;
            }
            case 2:{
                array = [[ScanURLHistory findScanHistoryRecordsWithLikeTimeSearch:beforeLikeString] retain];
                break;
            }
            case 3:{
                array = [[ScanURLHistory findScanHistoryRecordsWithNotLikeTodayTimeSearch:currentLikeString andYesterday:yesterdayLikeString andBoforeTime:beforeLikeString] retain];
                break;
            }
            default:{
                NSLog(@"find error by time");
                break;
            }
        }
        
        [self.historyResults addObject:array];
        [array release];
    }
    
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.downToolbar.segmentCtrl.selectedSegmentIndex == 1) { //书签
        
        static NSString * identifier1 = @"cell1";
        BookmarkTableViewCell * cellBook = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cellBook) {
            cellBook = [[[BookmarkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1] autorelease];
        }
        
        if ([self.resultArray count] == 0) {
            
            cellBook.textLabel.text = @"暂无书签";
            cellBook.operateView.hidden = YES;
            
        } else {

            Bookmark * bookmark = [self.resultArray objectAtIndex:indexPath.row];
            cellBook.titleLable.text = bookmark.bmTitle;
            cellBook.urlLable.text = bookmark.bmURL;
            
        }
        return cellBook;

    } else { //历史记录
        
        static NSString * identifier2 = @"cell2";
        HistoryURLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[HistoryURLTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2] autorelease];
        }
        
        if ([self.resultArray count] == 0) {
            
            cell.titleLable.text = @"暂无数据";
            cell.operateView.hidden = YES;
            
        } else {
            
            if (!closedHistoryResults[indexPath.section] && [[self.historyResults objectAtIndex:indexPath.section] count] == 0) {
          
                cell.titleLable.text = @"暂无数据";
                cell.urlLable.text = @"";
                cell.operateView.hidden = YES;
                
            } else {
            
                ScanURLHistory * scanResult = [[self.historyResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
                int number = [Bookmark findOneBookmarkByURL:scanResult.swScanURL];
                if (number) {
                    cell.addLabel.text = @"移除";
                } else {
                    cell.addLabel.text = @"添加";
                }
                
                cell.urlLable.text = scanResult.swScanURL;
                cell.titleLable.text = scanResult.swTitle;
                
            }
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.downToolbar.segmentCtrl.selectedSegmentIndex == 1) { //显示书签
        
        return [self.resultArray count] ? [self.resultArray count] : 1;
        
    } else { //显示历史记录
    
        if (!closedHistoryResults[section] && [[self.historyResults objectAtIndex:section] count] == 0) {
            return 1;
        }
        
        return closedHistoryResults[section] ? 0 : [[self.historyResults objectAtIndex:section] count];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.downToolbar.segmentCtrl.selectedSegmentIndex == 1) {
        return 1;
    } else {
        if ([self.historyResults count] > 4) {
            return 4;
        }
        return [self.historyResults count];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.downToolbar.segmentCtrl.selectedSegmentIndex == 1) { //选中书签
        
        if ([self.resultArray count] == 0) {
            return NO;
        }
        return YES;
        
    } else {
        
        if ([[self.historyResults objectAtIndex:indexPath.section] count] == 0) {
            return NO;
        }
        return YES;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.resultArray count] == 0) {  //一个元素都没
        return;
    }
    
    id obj = [self.resultArray objectAtIndex:0];
    Singleton * single = [Singleton shareSingleton];
    
    if ([obj isKindOfClass:[ScanURLHistory class]]) {
        
        if ([self.historyResults[indexPath.section] count] == 0) {
            return;
            
        } else {
            
            ScanURLHistory * scanResult = [self.historyResults[indexPath.section] objectAtIndex:indexPath.row];
            
            [single.homepageVC.aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:scanResult.swScanURL]]];
            
            [self.revealSideViewController popViewControllerWithNewCenterController:single.homepageVC animated:YES]; //返回首页页面
            
        }
        
    } else {
        
        Bookmark * bookmark = [self.resultArray objectAtIndex:indexPath.row];
        [single.homepageVC.aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:bookmark.bmURL]]];
        [self.revealSideViewController popViewControllerWithNewCenterController:single.homepageVC animated:YES];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    header.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    [header addSubview:lable];
    
    if (self.downToolbar.segmentCtrl.selectedSegmentIndex == 1) {
        lable.text = @"书签";
        [lable release];
        return [header autorelease];
    }
    
    lable.text = headerStings[section];
    [lable release];
    header.tag = section;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [header addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    return [header autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


#pragma mark -UITapGesture手势
- (void)goTapGesture:(UITapGestureRecognizer *)sender
{
    NSInteger num = sender.view.tag;
    
    NSMutableArray * array = [[NSMutableArray alloc] init]; //存放indexpath数组
    for (int i = 0; i < [self.historyResults[num] count]; i++) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:num];  //自动管理内存
        [array addObject:indexpath];
    }
    
    if ([[self.historyResults objectAtIndex:num] count] == 0) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:num];  //自动管理内存
        [array addObject:indexpath];

    }
    
    if(closedHistoryResults[num]) { //关闭
        
        closedHistoryResults[num] = closedHistoryResults[num] ? 0:1;
        [self.aTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
        
    } else { //打开
    
        closedHistoryResults[num] = closedHistoryResults[num] ? 0:1;
        [self.aTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
        
    }

    [array release];
}

#pragma mark - Add or Delete书签通知
- (void)addOneBookmark:(NSNotification *)notification
{
    NSString * urlString = [notification.userInfo objectForKey:@"url"];
    UILabel * label = [notification.userInfo objectForKey:@"label"];
    ScanURLHistory * scanURL = [ScanURLHistory findOneScanUrlHistoryResultByUrl:urlString];
    [Bookmark addOneBookmarkWithURL:urlString andTime:[self getCurrentStringDate] andTitle:scanURL.swTitle];  //添加书签
    label.text = @"移除";
    [self showHistoryResult];
}

- (void)deleteOneBookmark:(NSNotification *)notification
{
    NSString * urlString = [notification.userInfo objectForKey:@"url"];
    UILabel * label = [notification.userInfo objectForKey:@"label"];
    [Bookmark deleteOneBookmarkByURL:urlString];
    label.text = @"添加";
    [self showHistoryResult];
}

@end
