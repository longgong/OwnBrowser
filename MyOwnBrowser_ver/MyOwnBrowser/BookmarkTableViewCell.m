//
//  BookmarkTableViewCell.m
//  MyOwnBrowser
//
//  Created by gdm on 13-6-28.
//  Copyright (c) 2013年 龚道明. All rights reserved.
//

#import "BookmarkTableViewCell.h"

#define kDeleteBookmarkNotification @"deleteBookmark"

@implementation BookmarkTableViewCell

- (void)dealloc
{
    [_titleLable release];
    [_urlLable release];
    [_operateView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 276, 28)];
        [self.contentView addSubview:_titleLable];
        _titleLable.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15.0f];
        _titleLable.textColor = [UIColor orangeColor];
        
        _urlLable = [[UILabel alloc] initWithFrame:CGRectMake(4, 28, 276, 16)];
        [self.contentView addSubview:_urlLable];
        _urlLable.font = [UIFont systemFontOfSize:11];
        
        _operateView = [[UIView alloc] initWithFrame:CGRectMake(280, 8, 40, 28)];
        _operateView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_operateView];
        
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 30, 24)];
        aLabel.text = @"删除";
        aLabel.font = [UIFont systemFontOfSize:12.5];
        aLabel.textAlignment = NSTextAlignmentCenter;
        [_operateView addSubview:aLabel];
        [aLabel release];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDeleteAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [_operateView addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//执行删除操作
- (void)goDeleteAction:(UITapGestureRecognizer *)sender
{
    UILabel * urlLable = [self.contentView.subviews objectAtIndex:1];
    NSLog(@"%@",urlLable);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteBookmarkNotification object:self userInfo:@{@"url":urlLable.text}];
    
}

@end
