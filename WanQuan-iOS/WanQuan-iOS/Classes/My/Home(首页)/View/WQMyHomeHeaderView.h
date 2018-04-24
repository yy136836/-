//
//  WQMyHomeHeaderView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/11.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQMyHomeHeaderView : UIView
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *tagoncLabel;
@property (nonnull, retain) UIImageView * flagImageView;
@property (nonatomic, copy) void (^MyHomeHeaderbtnClikeBlock)();
@end
