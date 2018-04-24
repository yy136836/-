//
//  WQrewardTextView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/29.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQrewardTextView : UIView
@property (nonatomic,weak)UITextView *textView;
@property (nonatomic,weak)UIButton *submitBtn;
@property (nonatomic,weak)UIButton *cancelBtn;

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,copy) void(^submitBlock)(NSString * text);
@property (nonatomic,copy) void(^closeBlock)();
@end
