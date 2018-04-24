//
//  WQUpdatePopupwindowView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/3/5.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQUpdatePopupwindowView : UIView

/**
 版本号
 */
@property (nonatomic, strong) UILabel *versionNumberLabel;

/**
 更新内容
 */
@property (nonatomic, copy) NSString *contentString;

@end
