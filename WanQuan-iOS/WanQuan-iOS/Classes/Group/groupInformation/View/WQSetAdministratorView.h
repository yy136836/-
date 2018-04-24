//
//  WQSetAdministratorView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQSetAdministratorView;

@protocol WQSetAdministratorViewDelegate <NSObject>

/**
 设置管理员的响应事件

 @param setAdministratorView self
 */
- (void)wqSetAdministratorClick:(WQSetAdministratorView *)setAdministratorView;
@end

@interface WQSetAdministratorView : UIView

@property (nonatomic, weak) id <WQSetAdministratorViewDelegate> delegate;

@end
