//
//  WQBottomPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/8/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQBottomPopupWindowView;

@protocol WQBottomPopupWindowViewDelegate <NSObject>

/**
 拍完照确定的响应事件

 @param bottomPopupWindowView self
 @param image 回调的图片
 */
- (void)wqFinishAction:(WQBottomPopupWindowView *)bottomPopupWindowView image:(UIImage *)image;
- (void)wqDeleteBtnClick:(WQBottomPopupWindowView *)bottomPopupWindowView;
@end

@interface WQBottomPopupWindowView : UIView

@property (nonatomic, weak) id <WQBottomPopupWindowViewDelegate> delegate;

@property (nonatomic, assign) BOOL isIdcard_pic;

@end
