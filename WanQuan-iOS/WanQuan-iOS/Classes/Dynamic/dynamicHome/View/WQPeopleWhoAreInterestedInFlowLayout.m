//
//  WQPeopleWhoAreInterestedInFlowLayout.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPeopleWhoAreInterestedInFlowLayout.h"

@implementation WQPeopleWhoAreInterestedInFlowLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //拿到系统返回的所有的cell布局,对其进行修改,然后返回
    //获取已经显示出来的cell的布局
    NSArray *atts = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    //偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x;
    CGFloat W = self.collectionView.bounds.size.width;

    for (UICollectionViewLayoutAttributes *cellAtt in atts) {
        //cell离中心点距离为marginToCenter(显示出来的cell的中心点X值减去CollectionView宽度的一半与CollectionView偏移量的和)
        //距离不能是负数,因此要取绝对值
        CGFloat marginToCenter = fabs(cellAtt.center.x - (offsetX + W * 0.5));

        
        
        
        
        //获取缩放比例
        CGFloat scale = 1 - marginToCenter / (0.5 * W) * 0.15;
        NSLog(@"%f",scale);

        //形变
        cellAtt.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return atts;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    //自己验证的是系统默认返回NO,也就是不允许在滚动的时候刷新,也就是下面的prepareLayout只会在collectionView第一次显示的时候调用,返回YES的时候,就会在滚动的时候不停的调用
    //   return [super shouldInvalidateLayoutForBoundsChange:newBounds];

    return YES;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //最终偏移量 =? 手指抬起时候的偏移量collectionView的偏移量
    //慢慢拖,相等 ,如果很快的拖动,就不相等,这个是因为惯性,collectionView还要减速继续滚动到停止

    CGFloat W = self.collectionView.bounds.size.width;

    //获取最终显示的cell
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, W, MAXFLOAT);

    //给定一个区域,获取最终显示的cell
    NSArray *atts = [super layoutAttributesForElementsInRect:targetRect];

    //遍历数组,获取cell中心点离collectionView最近的那个cell
    CGFloat minMargin = MAXFLOAT;

    for (UICollectionViewLayoutAttributes *cellAtt in atts) {

        CGFloat marginToCenter = cellAtt.center.x - (proposedContentOffset.x + W * 0.5);
        if (fabs(marginToCenter) < fabs(minMargin)) {

            minMargin = marginToCenter;
        }

    }
    proposedContentOffset.x += minMargin;
    NSLog(@"%f",proposedContentOffset.x);

    //如果在程序运行之后,将collectionView向左边移动一点点,会出现最终偏移量为-0的情况,要解决这个bug,就要写下面的代码,不让它的偏移量出现负数
//    if (proposedContentOffset.x < 0) {
//        proposedContentOffset.x = 0;
//    }
    
    return proposedContentOffset;
}

- (void)prepareLayout {
    [super prepareLayout];
}

-(CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

@end
