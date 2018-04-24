//
//  TZPhotoPreviewView+WQResize.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "TZPhotoPreviewView+WQResize.h"
#import <UIView+Layout.h>
@implementation TZPhotoPreviewView (WQResize)
+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(resizeSubviews));
    Method m2 = class_getInstanceMethod(self, @selector(WQ_resizeSubviews));



    method_exchangeImplementations(m1, m2);
}


- (void)WQ_resizeSubviews {
    self.imageContainerView.tz_origin = CGPointZero;
    self.imageContainerView.tz_width = self.scrollView.tz_width;

    UIImage *image = self.imageView.image;
    if (image.size.height / image.size.width > self.tz_height / self.scrollView.tz_width) {
        self.imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.scrollView.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        
        self.imageContainerView.tz_height = height;
        self.imageContainerView.tz_centerY = self.tz_height / 2;
        if (image.size.width > image.size.height) {
            self.imageContainerView.tz_height = kScreenWidth;
            self.imageContainerView.tz_width = kScreenWidth * (image.size.width / image.size.height);
        }

        self.imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (self.imageContainerView.tz_height > self.tz_height && self.imageContainerView.tz_height - self.tz_height <= 1) {
        self.imageContainerView.tz_height = self.tz_height;
    }
    CGFloat contentSizeH = MAX(self.imageContainerView.tz_height, self.tz_height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.tz_width, contentSizeH);
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = self.imageContainerView.tz_height <= self.tz_height ? NO : YES;
    self.imageView.frame = self.imageContainerView.bounds;

    [self refreshScrollViewContentSize];
}

@end
