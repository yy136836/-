//
//  UIView+Addition.m
//  gh_load
//
//  Created by gh_load on 15/3/9.
//  Copyright © 2015年 gh_load. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod(self, @selector(removeFromSuperview));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(WQ_removeFromSuperView));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);

    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];

    // 能够关闭之后，取结果！
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    // 一定要先关闭，再返回
    return result;
}

- (void)WQ_removeFromSuperView {
    if (self.superview) {
        [self WQ_removeFromSuperView];
    }
}
@end
