//
//  BottomBookMarkToolbar.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-25.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "BottomBookMarkToolbar.h"

@implementation BottomBookMarkToolbar

- (void)dealloc
{
    [_segmentCtrl release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左侧" style:UIBarButtonItemStyleBordered target:self action:@selector(goLeftOrRightAction:)];
        leftItem.tag = 100;
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"右侧" style:UIBarButtonItemStyleBordered target:self action:@selector(goLeftOrRightAction:)];
        rightItem.tag = 101;
        
        UIBarButtonItem * anotherSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        anotherSpace.width = -2.3f;
        
        UISegmentedControl * segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"历史",@"书签"]];
        segmentCtrl.selectedSegmentIndex = 0;
        [segmentCtrl addTarget:self action:@selector(goHistoryOrBookMarkAction:) forControlEvents:UIControlEventValueChanged];
        segmentCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segmentCtrl = segmentCtrl;
        
        segmentCtrl.frame = CGRectMake(0, 0, 204, 32);
  
        
        UIBarButtonItem * middleItem = [[UIBarButtonItem alloc] initWithCustomView:segmentCtrl];
        
        [self setItems:@[leftItem,anotherSpace,middleItem,anotherSpace,rightItem] animated:YES];
        
        [leftItem release];
        [middleItem release];
        [rightItem release];
        [segmentCtrl release];
        
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

- (void)goLeftOrRightAction:(UIBarButtonItem *)sender
{
    if (sender.tag == 100) {
        [self.itemDelegate goBackToLeft];
    } else {
        [self.itemDelegate forwardToRight];
    }
}

- (void)goHistoryOrBookMarkAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self.itemDelegate showHistoryResult];
    } else {
        [self.itemDelegate showBookmarkResult];
    }
}

@end
