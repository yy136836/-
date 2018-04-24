//
//  WQGroupDemandForDetailsSharView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQGroupDemandForDetailsSharView;

@protocol WQGroupDemandForDetailsSharViewDelegate <NSObject>

/**
 点击屏幕的响应事件

 @param sharView self
 */
- (void)wqSharViewClick:(WQGroupDemandForDetailsSharView *)sharView;

/**
 置顶按钮的响应事件

 @param sharView self
 */
- (void)wqAtTopBtnClick:(WQGroupDemandForDetailsSharView *)sharView;

/**
 删除按钮响应事件

 @param sharView self
 */
- (void)wqDeleteBtnClick:(WQGroupDemandForDetailsSharView *)sharView;
@end

@interface WQGroupDemandForDetailsSharView : UIView

@property (nonatomic, weak) id <WQGroupDemandForDetailsSharViewDelegate> delegate;

@property (nonatomic, strong) UIButton *atTopBtn;

@end
