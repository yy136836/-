//
//  WQNewGroupView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQNewGroupView : UIView
// 群介绍
@property (nonatomic, strong) UITextView *contentTextView;
// 群头像
@property (nonatomic, strong) UIImageView *headImageView;
// 群名称
@property (nonatomic, strong) UITextField *nameInputBoxTextField;

@end
