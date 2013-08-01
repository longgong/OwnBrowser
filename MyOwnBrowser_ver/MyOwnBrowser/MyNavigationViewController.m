//
//  MyNavigationViewController.m
//  MyOwnBrowser
//
//  Created by gdm on 13-7-3.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "MyNavigationViewController.h"
#import "ScanURLHistory.h"
#import "Bookmark.h"
#import "Singleton.h"
#import "NavigationButton.h"
#import "IconNavigation.h"
#import <QuartzCore/QuartzCore.h>

@interface MyNavigationViewController ()
{
    NSString * connectUrlString;
    NSString * iconTitle; 
    BOOL showBookmarkResult; //默认显示历史，yes代表显示书签，no代表显示历史记录
    
    BOOL firstHistoryClick; //第一次点击历史记录行
    
    BOOL firstBookClick; //第一次点击书签行
    
    NavigationButton * nab; //点确认添加的导航按钮
}
@end

@implementation MyNavigationViewController

- (void)dealloc
{
    [_aTableView release];
    [_segCtrl release];
    [_resultDatas release];
    [_aBookmarkTableView release];
    [_bookmarkDatas release];
    [_receiveData release];
    [_currentIndexPath release];
    [_iconName release];
    
    [_bookmarkIndexPath release];
    [_historyIndexPath release];
    NSLog(@"my navigation dealloc");
    [super dealloc];
}

- (void)prepareUI
{
    _resultDatas = [[NSMutableArray alloc] init];
    _bookmarkDatas = [[NSMutableArray alloc] init];
    [self readWithSectionsScanHistoryDatas];
    
    _aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44-44) style:UITableViewStylePlain];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView];
    
    _aBookmarkTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 460-44-44) style:UITableViewStylePlain];
    _aBookmarkTableView.delegate = self;
    _aBookmarkTableView.dataSource = self;
    [self.view addSubview:_aBookmarkTableView];
    
    _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"历史",@"书签"]];
    _segCtrl.frame = CGRectMake(0, 460-44-44, 320, 44);
    _segCtrl.selectedSegmentIndex = 0;
    [_segCtrl addTarget:self action:@selector(doHistoryOrBookMarkAction:) forControlEvents:UIControlEventValueChanged];
    _segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.view addSubview:_segCtrl];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(goNavigationBarButtonItemAction:)];
    leftItem.tag = 100;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(goNavigationBarButtonItemAction:)];
    rightItem.tag = 101;
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [leftItem release];
    [rightItem release];
    //给初始值
    showBookmarkResult = NO;
    firstBookClick = YES;
    firstHistoryClick = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self prepareUI];
    self.navigationItem.title = @"我的导航";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doHistoryOrBookMarkAction:(UISegmentedControl *)sender
{
    
    if (sender.selectedSegmentIndex == 0) { //历史
        
        [self readWithSectionsScanHistoryDatas];
        [self.aTableView reloadData];
        [self showHistoryDatas];
        
    } else {
        
        self.bookmarkDatas = [Bookmark findAllBookmark];
        [self.aBookmarkTableView reloadData];
        [self showBookmarkDatas];
    }
    
}

- (void)showBookmarkDatas
{
    CATransition * transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    self.aBookmarkTableView.frame = CGRectMake(0, 0, 320, 460-44-44);
    self.aTableView.frame = CGRectMake(-320, 0, 320, 460-88);
    [self.aBookmarkTableView.layer addAnimation:transition forKey:nil];
    [self.aTableView.layer addAnimation:transition forKey:nil];
    showBookmarkResult = YES;
}

- (void)showHistoryDatas
{
    CATransition * transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.aTableView.frame = CGRectMake(0, 0, 320, 460-44-44);
    self.aBookmarkTableView.frame = CGRectMake(320, 0, 320, 460-88);
    [self.aBookmarkTableView.layer addAnimation:transition forKey:nil];
    [self.aTableView.layer addAnimation:transition forKey:nil];
    showBookmarkResult = NO;
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
        
        [self.resultDatas addObject:array];
        [array release];
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segCtrl.selectedSegmentIndex == 1) { //选中书签
        
        static NSString * identifier1 = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1] autorelease];
        }
        
        if ([self.bookmarkDatas count] == 0) {
            cell.textLabel.text = @"暂无书签";
            cell.detailTextLabel.text = @"";
        
        } else {
            Bookmark * bookmark = [self.bookmarkDatas objectAtIndex:indexPath.row];
            cell.textLabel.text = bookmark.bmTitle;
            cell.detailTextLabel.text = bookmark.bmURL;
        }
        
        return cell;
        
    } else { //选中历史
        
        static NSString * identifier2 = @"cell2";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2] autorelease];
            NSLog(@"alloc");
            
        }
        if ([self.resultDatas count] == 0) {
            cell.textLabel.text = @"暂无记录";
            cell.detailTextLabel.text = @"";
        } else {
            
            if (!closedHistoryResults[indexPath.section] && [[self.resultDatas objectAtIndex:indexPath.section] count] == 0) {
                
                cell.textLabel.text = @"暂无记录";
                cell.detailTextLabel.text = @"";
                
            } else {
                
                ScanURLHistory * scan = [[self.resultDatas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                cell.textLabel.text = scan.swTitle;
                cell.detailTextLabel.text = scan.swScanURL;
                
            }
            
        }

        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segCtrl.selectedSegmentIndex == 1) {//选中书签
        return [self.bookmarkDatas count] ? [self.bookmarkDatas count] : 1;
    } else {
        if (!closedHistoryResults[section] && [[self.resultDatas objectAtIndex:section] count] == 0) {
            return 1;
        }
        
        return closedHistoryResults[section] ? 0 : [[self.resultDatas objectAtIndex:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segCtrl.selectedSegmentIndex == 1) { //选中书签
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    header.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    [header addSubview:lable];
    
    if (self.segCtrl.selectedSegmentIndex == 1) { // 选中书签
        
        lable.backgroundColor = [UIColor purpleColor];
        lable.text = @"书签";
        [lable release];
        return [header autorelease];
    }
    
    lable.backgroundColor = [UIColor cyanColor];
    switch (section) {
        case 0:{
            lable.text = @"今天浏览记录";
            break;
        }
        case 1:{
            lable.text = @"昨天浏览记录";
            break;
        }
        case 2:{
            lable.text = @"前天浏览记录";
            break;
        }
        case 3:{
            lable.text = @"更多浏览记录";
            break;
        }
        default:
            break;
    }
    
    header.tag = section;
    [lable release];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNavigationTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [header addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    return [header autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if (self.segCtrl.selectedSegmentIndex == 1) { //选中书签
        
        if (firstBookClick) {
            self.bookmarkIndexPath = indexPath;
            
            firstBookClick = NO;
        } else{
            NSLog(@"ttt");
            
            if (self.bookmarkIndexPath.section != indexPath.section || self.bookmarkIndexPath.row != indexPath.row) {
                UITableViewCell * cell1 = [tableView cellForRowAtIndexPath:self.bookmarkIndexPath];
                cell1.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        self.bookmarkIndexPath = indexPath; //记录上一次indexpath
        
    } else {
        
        if (firstHistoryClick) {
            NSLog(@"1111");
            self.historyIndexPath = indexPath;
            firstHistoryClick = NO;
            
        } else{
            
            
            if (self.historyIndexPath.section != indexPath.section || self.historyIndexPath.row != indexPath.row) {
                NSLog(@"oooo");
                UITableViewCell * cell2 = [tableView cellForRowAtIndexPath:self.historyIndexPath];
                cell2.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        self.historyIndexPath = indexPath;
        
    }
    self.currentIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //设置完后取消选中该行
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segCtrl.selectedSegmentIndex == 1) { //选中书签
        
        if ([self.bookmarkDatas count] == 0) {
            return NO;
        }
        return YES;
        
    } else {
        
        if ([[self.resultDatas objectAtIndex:indexPath.section] count] == 0) {
            return NO;
        }
        return YES;
        
    }
}

#pragma mark -UITapGesture手势
- (void)goNavigationTapGesture:(UITapGestureRecognizer *)sender
{
    NSInteger num = sender.view.tag;
        
    NSMutableArray * array = [[NSMutableArray alloc] init]; //存放indexpath数组
    for (int i = 0; i < [self.resultDatas[num] count]; i++) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:num];  //自动管理内存
        [array addObject:indexpath];
    }
    
    if ([[self.resultDatas objectAtIndex:num] count] == 0) {
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

- (void)getAsynchronous:(NSString *)urlString
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receiveData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * targetPath = [docPath stringByAppendingPathComponent:@"navigationBtnIcon/loadImgIcon"];//文件夹名
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:targetPath]) {
        [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * path = [targetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.iconName]];
    [self.receiveData writeToFile:path atomically:YES]; //图片写入本地
    [IconNavigation addOneIconWithURL:connectUrlString andIconString:self.iconName andIconFormatter:@"png" andTitle:iconTitle];
    self.receiveData = nil;
    
    //图片写入本地后才显示
    Singleton * single = [Singleton shareSingleton];
    [single.leftPageVC.iconDatas removeAllObjects];
    single.leftPageVC.iconDatas = [IconNavigation findAllIconInfos];
    IconNavigation * lastIcon = [single.leftPageVC.iconDatas lastObject];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    UIImage * img = [[UIImage alloc] initWithContentsOfFile:path];//读图片
    nab.img = img;
    nab.urlString = lastIcon.niIconURL;
    nab.iconDelegate = single.leftPageVC;
    nab.titleLabel.text = lastIcon.niTitle;
    [UIView commitAnimations];
    [img release];
    [single.leftPageVC adjustScrollViewContentSize];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"urlConnection error =  %@",[error localizedDescription]);
    self.receiveData = nil;
}

#pragma mark - UIBarbuttonItem响应方法
- (void)goNavigationBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (sender.tag == 100) { //取消
        [self dismissViewControllerAnimated:YES completion:nil];
    } else { //确定
        
        
        
        Singleton * single = [Singleton shareSingleton];
        if (self.segCtrl.selectedSegmentIndex == 1) {
            //拿网址
            Bookmark * bookmark = [self.bookmarkDatas objectAtIndex:_currentIndexPath.row];
            iconTitle = bookmark.bmTitle;
            NSString * icoStr = [self cutIconUrlString:bookmark.bmURL];
            
            //有重复的图标则不添加导航栏，查找图标名字
            if ([IconNavigation findOneIconName:_iconName]) {
                single.isAddingFail = YES;
                single.navigationIconName = _iconName;
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            
            [self getAsynchronous:icoStr];
        } else {
            //拿网址
            ScanURLHistory * scan = [[self.resultDatas objectAtIndex:_currentIndexPath.section] objectAtIndex:_currentIndexPath.row];
            iconTitle = scan.swTitle;
            NSString * icoStr = [self cutIconUrlString:scan.swScanURL];
            
            if ([IconNavigation findOneIconName:_iconName]) {
                single.isAddingFail = YES;
                single.navigationIconName = _iconName;
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            
            [self getAsynchronous:icoStr];
            
        }
        [self addOneNavigationButton];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addOneNavigationButton
{
    Singleton * single = [Singleton shareSingleton];
    
    nab = [[NavigationButton alloc] initWithFrame:CGRectMake(single.leftPageVC.iconRowWidth, single.leftPageVC.iconColumnHeight, 70, 70)];

    [single.leftPageVC.aScrollView addSubview:nab];
        
    if (single.leftPageVC.iconRowWidth > 140) {
        single.leftPageVC.iconRowWidth = 10;
        single.leftPageVC.iconColumnHeight += 80;
    } else {
        single.leftPageVC.iconRowWidth += 80;
    }
    
    self.AddNavigation.frame = CGRectMake(single.leftPageVC.iconRowWidth, single.leftPageVC.iconColumnHeight, 70, 70);
    
}

//截取图标网址方法
- (NSString *)cutIconUrlString:(NSString *)theUrlString
{
    connectUrlString = theUrlString; //获取导航图标请求网址
    NSRange range = [theUrlString rangeOfString:@".com"];
    NSString * str = [theUrlString substringToIndex:range.location+range.length];
    
    NSArray * arr = [str componentsSeparatedByString:@"."];
    NSLog(@"arr = %@",arr);
    _iconName = [[NSMutableString alloc] init];
    for (int i = 1; i < [arr count] -1; i++) { //获取图片名字
        [self.iconName appendString:arr[i]];
    }
    
    return [str stringByAppendingFormat:@"/favicon.ico"];
}

@end
