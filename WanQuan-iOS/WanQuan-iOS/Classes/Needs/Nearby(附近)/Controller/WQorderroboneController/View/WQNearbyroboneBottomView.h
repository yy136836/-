//
//  WQNearbyroboneBottomView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQNearbyroboneBottomView;

@protocol WQNearbyroboneBottomViewDelegate <NSObject>

/**
 提交的响应事件

 @param bottomView
 */
- (void)wqSubmitBtnClick:(WQNearbyroboneBottomView *)bottomView;
@end

@interface WQNearbyroboneBottomView : UIView

@property (nonatomic, weak) id <WQNearbyroboneBottomViewDelegate> delegate;

@end
