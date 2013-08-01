//
//  MySearchToolBar.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-20.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "MySearchToolBar.h"

#define kURLSearchBarOriginalFrame CGRectMake(0,0,200,44)
#define kURLSearchBarDestinationFrame CGRectMake(-200,0,200,44)

#define kKeyWordSearchBarOriginalFrame CGRectMake(200,0,120,44)
#define kKeyWordSearchBarDestinationFrame CGRectMake(320,0,120,44)

@implementation MySearchToolBar
@synthesize urlSearchBar = _urlSearchBar,urlSearchController = _urlSearchController,keywordSearchBar = _keywordSearchBar,keywordSearchController = _keywordSearchController,rootViewController = _rootViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _urlSearchBar = [[UISearchBar alloc] initWithFrame:kURLSearchBarOriginalFrame];
        _urlSearchBar.keyboardType = UIKeyboardTypeURL;
        _urlSearchBar.tag = 100;
        
        _keywordSearchBar = [[UISearchBar alloc] initWithFrame:kKeyWordSearchBarOriginalFrame];
        _keywordSearchBar.tag = 101;
        
        [self addSubview:_urlSearchBar];
        [self addSubview:_keywordSearchBar];
        
        for (UIView * aView in _urlSearchBar.subviews) {
            if ([aView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [aView removeFromSuperview];
            }
        }
/*
  <UISearchBarBackground: 0x75c0b40; frame = (0 0; 120 44); userInteractionEnabled = NO; layer = <CALayer: 0x75c0bb0>> - (null)
  2013-06-20 16:34:12.095 MyOwnBrowser[1506:c07] id = <UISearchBarTextField: 0x75bf510; frame = (0 0; 0 0); clipsToBounds = YES; opaque = NO; gestureRecognizers = <NSArray: 0x75bfb00>; layer = <CALayer: 0x75bed10>>
*/
        for (UIView * aView in _keywordSearchBar.subviews) {
            if ([aView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [aView removeFromSuperview];
            }
        }
        
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
//重写根视图控制器的set方法
- (void)setRootViewController:(UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate> *)rootViewController
{
    if (_rootViewController != rootViewController) {
        [_rootViewController release];
        _rootViewController = [rootViewController retain];
        
        self.urlSearchBar.delegate = _rootViewController; //代理里面要写实现的方法
        self.keywordSearchBar.delegate = _rootViewController;
        
        _urlSearchController = [[UISearchDisplayController alloc] initWithSearchBar:self.urlSearchBar contentsController:_rootViewController];
        _urlSearchController.delegate = _rootViewController;
        _urlSearchController.searchResultsDataSource = _rootViewController;
        _urlSearchController.searchResultsDelegate = _rootViewController;
        
        _keywordSearchController = [[UISearchDisplayController alloc] initWithSearchBar:self.keywordSearchBar contentsController:_rootViewController];
        _keywordSearchController.delegate = _rootViewController;
        _keywordSearchController.searchResultsDelegate = _rootViewController;
        _keywordSearchController.searchResultsDataSource = _rootViewController;
    }
}

- (void)mySearchBarWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    if ([controller isEqual:self.urlSearchController]) {
        self.keywordSearchBar.frame = kKeyWordSearchBarDestinationFrame;
    } else {

        self.keywordSearchBar.frame = CGRectMake(0, 0, 320, 44);
        self.urlSearchBar.frame = kURLSearchBarDestinationFrame;
       
    }
    [UIView commitAnimations];
}

- (void)mySearchBarDidBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.frame = CGRectMake(0, 0, 320, 44);
}

- (void)mySearchBarWillEndSearch:(UISearchDisplayController *)controller
{
    if ([controller isEqual:self.urlSearchController]) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        _urlSearchBar.frame = kURLSearchBarOriginalFrame;
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4f];
        _keywordSearchBar.frame = kKeyWordSearchBarOriginalFrame;
        [UIView commitAnimations];
        
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        _urlSearchBar.frame = kURLSearchBarOriginalFrame;
        _keywordSearchBar.frame = kKeyWordSearchBarOriginalFrame;
        [UIView commitAnimations];
    }
    //此时修改的searchbar的frame 若在执行完搜索后没改回来，此时这里修改的值将会又变成searchbar正在搜索时的frame值
}

- (void)mySearchBarDidEndSearch:(UISearchDisplayController *)controller
{
    _urlSearchBar.frame = kURLSearchBarOriginalFrame;
    _keywordSearchBar.frame = kKeyWordSearchBarOriginalFrame;
}

- (void)setActiveWithUrlSearchCtrlandKeywordSearchCtrl:(BOOL)active
{
    [self.urlSearchController setActive:NO animated:YES];
    [self.keywordSearchController setActive:NO animated:YES];
}

@end
