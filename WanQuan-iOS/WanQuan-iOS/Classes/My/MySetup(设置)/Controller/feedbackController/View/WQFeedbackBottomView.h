//
//  WQFeedbackBottomView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQFeedbackBottomView;

@protocol WQFeedbackBottomViewDelegate <NSObject>

- (void)wqSubmitBtnClick:(WQFeedbackBottomView *)bottomView;

@end

@interface WQFeedbackBottomView : UIView

@property (nonatomic, weak) id <WQFeedbackBottomViewDelegate> delegate;

@end
