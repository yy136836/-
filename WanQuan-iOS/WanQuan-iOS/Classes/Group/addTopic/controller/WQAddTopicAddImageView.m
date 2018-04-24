//
//  WQAddTopicAddImageView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQAddTopicAddImageView.h"


@interface WQAddTopicAddImageView ()



@end


@implementation WQAddTopicAddImageView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
    }
    return self;
}

@end
