//
//  WQdetailsBottomView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQdetailsBottomView;

@protocol WQdetailsBottomViewDelegate <NSObject>
- (void)askBtnClick:(WQdetailsBottomView *)bottomView;
@end

@interface WQdetailsBottomView : UIView

@property (nonatomic, weak) id <WQdetailsBottomViewDelegate> delegate;

@property (nonatomic, strong) UIView *redView;

@end
