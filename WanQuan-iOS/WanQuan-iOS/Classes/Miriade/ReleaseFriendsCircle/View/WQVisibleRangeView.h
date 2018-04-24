//
//  WQVisibleRangeView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQVisibleRangeView;

@protocol WQVisibleRangeViewDelegate <NSObject>

/**
 tableview某行的响应事件
 
 @param visibleRangeView self

 @param index 0:公开   1:好友和二度好友 2:好友可见
 */
- (void)wqTableViewdidSelectRow:(WQVisibleRangeView *)visibleRangeView index:(NSInteger)index;

@end

@interface WQVisibleRangeView : UIView

@property (nonatomic, weak) id <WQVisibleRangeViewDelegate> delegate;

@end
