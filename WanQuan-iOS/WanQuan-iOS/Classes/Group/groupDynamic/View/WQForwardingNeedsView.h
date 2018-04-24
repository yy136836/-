//
//  WQForwardingNeedsView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQForwardingNeedsView : UIView
// 用户名
@property (nonatomic, strong) UILabel *userNameLabel;
// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 内容
@property (nonatomic, strong) UILabel *contentLabel;
// 红包
@property (nonatomic, strong) UIImageView *forwarDingHongbao;
@end
