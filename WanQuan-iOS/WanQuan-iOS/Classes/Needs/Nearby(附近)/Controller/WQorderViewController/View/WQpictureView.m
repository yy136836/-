//
//  WQpictureView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQpictureView.h"
#import "WQStatusPictureViewCell.h"
#import "WQPhotoBrowser.h"

static NSString *cellId = @"cellid";

@interface WQpictureView() <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WQpictureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[WQStatusPictureViewCell class] forCellWithReuseIdentifier:cellId];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setPicArray:(NSArray *)picArray
{
    _picArray = picArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WQStatusPictureViewCell *cell = (WQStatusPictureViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    CGRect cellFrame = [cell convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
//    //CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:indexPath.row willShowImageUrls:self.pic_urls];
//    CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:indexPath.item willShowImages:self.picArray];
//    imageShowView.showPageControl = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(120, 120);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQStatusPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.picString = self.picArray[indexPath.row];
    
    __weak typeof(cell) weakCell = cell;
    
    [cell setImageClilcBlock:^(UIImageView *imageView) {
        
        CGRect cellFrame = [weakCell convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
        WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
        browser .currentPhotoIndex = indexPath.row;
        browser.alwaysShowControls = NO;
        
        browser.displayActionButton = NO;
        
        browser.shouldTapBack = YES;
        
        browser.shouldHideNavBar = YES;
        [self.viewController.navigationController pushViewController:browser animated:YES];
    }];
    return cell;
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:[imageUrlString stringByAppendingString:_picArray[index]]];
    
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    return photo;
    
}


@end
