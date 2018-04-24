//
//  WQlittleHelperStatusToolBarView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/7.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQlittleHelperStatusToolBarView : UIView
//赞.评论的conut
@property (strong, nonatomic) UILabel *likeLabel;
@property (strong, nonatomic) UILabel *CommentsLabel;

/**
 赞
 */
@property (nonatomic, strong) UIButton *unlikeBtn;

@property (nonatomic, copy) void(^commentBtnBlock)();
@property (nonatomic, copy) void(^unlikeBtnBlock)();

@property (nonatomic, assign) BOOL isHome;

@end
