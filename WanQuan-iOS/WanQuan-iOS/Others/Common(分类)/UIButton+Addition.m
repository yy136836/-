 //
//  UIButton+Addition.m
//  gh_load
//
//  Created by gh_load on 16/7/19.
//  Copyright © 2016年 gh_load. All rights reserved.
//

#import "UIButton+Addition.h"
#import <objc/runtime.h>

static char* btnActionKey = "btnActionKey";

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@interface UIButton ()

@property (nonatomic, copy) addActionBlock addAction;

 
@end

@implementation UIButton (Addition)

- (void)setEnlargeEdge:(CGFloat) size {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}



+ (instancetype)setNormalTitle:(NSString *)normalTitle andNormalColor:(UIColor *)color andFont:(CGFloat)font {
    return [self setAttributas:UIControlStateNormal andTitle:normalTitle andNormalColor:color andFont:font];
}

+ (instancetype)setHighlightedTitle:(NSString *)highlightedTitle andHighlightedColor:(UIColor *)color andFont:(CGFloat)font {
    return [self setAttributas:UIControlStateHighlighted andTitle:highlightedTitle andNormalColor:color andFont:font];
}

+ (UIButton *)setAttributas:(NSUInteger)UIControlState andTitle:(NSString *)title andNormalColor:(UIColor *)color andFont:(CGFloat)font {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlState];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:UIControlState];
    if (UIControlState == UIControlStateNormal) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }

    [btn sizeToFit];
    return btn;
}

- (void)setAddAction:(addActionBlock)addAction {
    // 获取关联对象
    objc_setAssociatedObject(self, btnActionKey, addAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (addActionBlock)addAction {
    // 关联的对象
    return objc_getAssociatedObject(self, btnActionKey);
}

- (void)btnAction:(UIButton *)sender {
    if (self.addAction) {
        self.addAction(sender);
    }
}

- (void)addClickAction:(addActionBlock)addAction {
    self.addAction = addAction;
    [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}


//- (void)setBadgeView:(UIView *)badgeView {
//    
//    if (objc_getAssociatedObject(self, @"badgeView")) {
//        return;
//    }
//    
//    UIView * badge = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 8, 5, 3, 3)];
//    [self addSubview:badge];
//    
//    objc_setAssociatedObject(self, "badgeView", badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


@end
