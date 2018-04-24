//
//  WQVisitorsToLoginPopupWindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/29.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQVisitorsToLoginPopupWindowView;

@protocol WQVisitorsToLoginPopupWindowViewDelegate <NSObject>
/**
 退出登录的响应事件

 @param popupWindowView self
 */
- (void)wqLogOutBtnClick:(WQVisitorsToLoginPopupWindowView *)popupWindowView;
/**
 补充信息的响应事件

 @param popupWindowView self
 */
- (void)wqSupplementaryInformationBtnClick:(WQVisitorsToLoginPopupWindowView *)popupWindowView;
@end

@interface WQVisitorsToLoginPopupWindowView : UIView

@property (nonatomic, weak) id <WQVisitorsToLoginPopupWindowViewDelegate> delegate;

@end
