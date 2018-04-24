//
//  WQAlreadyReceiveView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/7/14.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQAlreadyReceiveView;

@protocol WQAlreadyReceiveViewDelegate <NSObject>

- (void)shutDownBtnClikeWQAlreadyReceiveView:(WQAlreadyReceiveView *)alreadyReceiveView;

@end

@interface WQAlreadyReceiveView : UIView

@property (nonatomic, weak) id <WQAlreadyReceiveViewDelegate>delegate;

/**
 金额
 */
@property (nonatomic, copy) NSString *moneyString;

@end
