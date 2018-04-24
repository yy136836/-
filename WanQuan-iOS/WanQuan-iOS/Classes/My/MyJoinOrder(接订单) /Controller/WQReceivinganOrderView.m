
//
//  WQReceivinganOrderView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQReceivinganOrderView.h"

@implementation WQReceivinganOrderView

+(UICollectionView *)collectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    return collectionView;
}

@end
