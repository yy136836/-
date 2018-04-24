//
//  WQOrderCollectionView.m
//
//  Created by 
//  Copyright © 2016年 shihua. All rights reserved.
//

#import "WQOrderCollectionView.h"

@implementation WQOrderCollectionView

+ (UICollectionView *)collectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    return collectionView;
}

@end
