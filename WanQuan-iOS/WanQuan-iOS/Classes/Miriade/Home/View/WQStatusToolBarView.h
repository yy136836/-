//
//  WQStatusToolBarView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/13.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQStatusToolBarView : UIView
//赞.踩,评论的conut
@property (strong, nonatomic) UILabel *likeLabel;
@property (strong, nonatomic) UILabel *TreadLable;
@property (strong, nonatomic) UILabel *CommentsLabel;

/**
 赞
 */
@property (strong, nonatomic) UIButton *unlikeBtn;
@property (assign, nonatomic) int like_count;

@property (nonatomic, copy) void(^unlikeBtnBlock)();
@property (nonatomic, copy) void(^retweetbtnBlock)();
@property (nonatomic, copy) void(^commentBtnBlock)();
@property (nonatomic, copy) void(^playTourBtnClikeBlock)();
@end
