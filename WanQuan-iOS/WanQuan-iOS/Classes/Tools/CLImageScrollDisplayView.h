//
//  bohe
//
//  Created by 郭杭 on 15/12/16.
//  Copyright © 2015年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLImageScrollDisplayView : UICollectionView

/**
 @param frame 相对于keyWindow的frame
 @param index 当前点击的图片是第几张
 @param images 图片数组

 */
- (instancetype)initWithConverFrame:(CGRect)frame index:(NSInteger)index willShowImages:(NSArray<UIImage *> *)images;

/**
 @param frame 相对于keyWindow的frame
 @param index 当前点击的图片是第几张
 @param imagesUrls 图片url数组
 
 */
- (instancetype)initWithConverFrame:(CGRect)frame index:(NSInteger)index willShowImageUrls:(NSArray<NSString *> *)imagesUrls;

@property (assign, nonatomic,getter=isShowPageControl) BOOL showPageControl; // 是否显示pageControl
@property (strong, nonatomic) UIColor *pageControlCurrentColor; // pageControl当前页的颜色，默认灰色
@property (strong, nonatomic) UIColor *pageIndicatorColor;  // pageControl非选页的颜色，默认白色

@end
