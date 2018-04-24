//
//  WQLoginAreaCodeHeadView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/8.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQLoginAreaCodeHeadView;

@protocol WQLoginAreaCodeHeadViewDelegate <NSObject>

/**
 x号的响应事件

 @param headView self
 */
- (void)wqShutDownBtnClick:(WQLoginAreaCodeHeadView *)headView;
@end

@interface WQLoginAreaCodeHeadView : UIView

@property (nonatomic, weak) id <WQLoginAreaCodeHeadViewDelegate> delegate;
@end
