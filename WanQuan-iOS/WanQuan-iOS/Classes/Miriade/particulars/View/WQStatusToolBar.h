//
//  WQStatusToolBar.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQStatusToolBar : UIView

/**
 赞的按钮
 */
@property (strong, nonatomic) UIButton *unlikeBtn;
@property (strong, nonatomic) UILabel *likeLabel;     //赞.踩,评论的conut
@property (strong, nonatomic) UILabel *TreadLable;
@property (strong, nonatomic) UILabel *CommentsLabel;

@property (nonatomic, copy) void(^likeBtnClikeBlock)();
@property (nonatomic, copy) void(^treadBtnClikeBlock)();
@property (nonatomic, copy) void(^commentsBtnClikeBlock)();
@property (nonatomic, copy) void(^playTourBtnClikeBlock)();
@end
