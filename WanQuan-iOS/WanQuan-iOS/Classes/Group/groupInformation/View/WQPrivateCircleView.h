//
//  WQPrivateCircleView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/11/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQPrivateCircleView : UIView

/**
 gid
 */
@property (nonatomic, copy) NSString *gid;
/**
 是否从新建圈过来的
 */
@property (nonatomic, assign) BOOL isNewGroup;

/**
 是否隐私圈的开关
 */
@property (nonatomic, strong) UISwitch *wqSwitch;

@end
