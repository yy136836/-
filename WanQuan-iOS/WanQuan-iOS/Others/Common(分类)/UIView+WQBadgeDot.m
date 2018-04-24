//
//  UIView+WQBadgeDot.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/5/2.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UIView+WQBadgeDot.h"
#import "WZLBadgeImport.h"
@implementation UIView (WQBadgeDot)

//- (UIView *)badge {
//    
//    if (!objc_getAssociatedObject(self, "badgeView")) {
//        UIView * badgeView = [[UIView alloc] init];
//        [self addSubview:badgeView];
////        [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.right.equalTo(self.mas_right).offset(-8);
////            make.top.equalTo(self.mas_top).offset(5);
////            make.width.equalTo(@5);
////            make.height.equalTo(@5);
////        }];
//        badgeView.frame = CGRectMake(self.width - 10, 10, 7, 7);
//        
//        badgeView.layer.cornerRadius = 3.5;
//        badgeView.layer.masksToBounds = YES;
//        badgeView.backgroundColor = [UIColor redColor];
//        badgeView.hidden = YES;
//        
//        objc_setAssociatedObject(self, "badgeView", badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//    }
//    return objc_getAssociatedObject(self, "badgeView");
//}




- (void)setBadgeView:(UIView *)badge {
    
    return;
}

- (void)showDotBadge {
    [self showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
}
- (void)hideDotBadge {
    [self clearBadge];
}


@end
