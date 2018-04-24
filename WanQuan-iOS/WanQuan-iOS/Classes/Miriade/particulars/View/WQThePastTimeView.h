//
//  WQThePastTimeView.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQThePastTimeView : UIView
@property (nonatomic, assign) NSInteger thePastTime;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^deleteBtnClikeBlock)();
@end
