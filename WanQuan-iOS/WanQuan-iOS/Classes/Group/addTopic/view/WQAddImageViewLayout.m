//
//  WQAddImageViewLayout.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddImageViewLayout.h"

@implementation WQAddImageViewLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        //设置每个item的大小  这个属性最好在控制器中设置
        self.itemSize = CGSizeMake(110, 125);
        //设置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置每行的最小间距
        self.minimumLineSpacing = 10;
    } 
    return self;
}






-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
