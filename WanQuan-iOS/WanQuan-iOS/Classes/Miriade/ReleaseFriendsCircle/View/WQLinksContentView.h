//
//  WQLinksContentView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLinksContentView;

@protocol WQLinksContentViewDelegate <NSObject>

/**
 X号的响应事件

 @param linksContentView self
 */
- (void)deleteBtnClick:(WQLinksContentView *)linksContentView;
@end

@interface WQLinksContentView : UIView

@property (nonatomic, weak) id <WQLinksContentViewDelegate> delegate;

/**
 链接图片
 */
@property (nonatomic, strong) UIImageView *linksImage;

/**
 链接title
 */
@property (nonatomic, strong) UILabel *linksLabel;


/**
 是否从万圈详情和万圈首页过来的  是: YES
 */
@property (nonatomic, assign) BOOL isWanquanHome;

@end
