//
//  WQLoadingView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/24.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQLoadingView : UIView

@property (nonatomic, strong) UIImageView *imageView;

- (void)dismiss;

- (void)show;

@end
