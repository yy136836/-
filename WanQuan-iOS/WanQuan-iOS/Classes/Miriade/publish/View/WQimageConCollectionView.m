
//
//  WQimageConCollectionView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/14.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQimageConCollectionView.h"
#import "WQimageConCollectionViewCell.h"
#import "WQPhotoBrowser.h"

NSString *cellid = @"composePictureCell";

@interface WQimageConCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,MWPhotoBrowserDelegate>

@end

@implementation WQimageConCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor orangeColor];
        [self setupUI];
    }
    return self;
}
#pragma mark -- 初始化UI
- (void)setupUI {
    [self registerClass:[WQimageConCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    self.dataSource = self;
    self.delegate = self;
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    self.hidden = true;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat itemHW = (self.frame.size.width - 2 * ghitemMargin) / 3;
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    layout.minimumLineSpacing = ghitemMargin;
    layout.minimumInteritemSpacing = ghitemMargin;
}

- (void)addImageWithImgae:(UIImage *)image {
    if (_imageArray.count < 9) {
        [_imageArray addObject:image];
        [self reloadData];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请勿上传过多图片"];
    }
}

#pragma mark -- CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_imageArray.count == 0 || _imageArray.count == 9)? _imageArray.count : _imageArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQimageConCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    self.hidden = self.imageArray.count == 0;
    if (indexPath.row < _imageArray.count) {
        cell.image = _imageArray[indexPath.row];
    }else {
        cell.image = nil;
    }
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^{
        [weakSelf.imageArray removeObjectAtIndex:indexPath.item];
        [weakSelf reloadData];
        weakSelf.hidden = weakSelf.imageArray.count == 0;
        if (weakSelf.deleteBlock) {
            weakSelf.deleteBlock();
        }
    };
    if (weakSelf.cellhiddenBlock) {
        weakSelf.cellhiddenBlock(indexPath.row);
    }
    __weak typeof(cell) weakCell = cell;
    // 图片的响应事件
    [cell setImageClilcBlock:^{
        if (indexPath.row == _imageArray.count) {
            if (self.addImageBlock) {
                self.addImageBlock();
            }
            return ;
        }
        if (weakCell.viewController.navigationController) {
            WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
            browser .currentPhotoIndex = indexPath.row;
            browser.alwaysShowControls = NO;
            browser.displayActionButton = NO;
            browser.shouldTapBack = YES;
            browser.shouldHideNavBar = YES;
            [weakCell.viewController presentViewController:browser animated:NO completion:nil];
        }
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (indexPath.row == _imageArray.count) {
        if (self.addImageBlock) {
            self.addImageBlock();
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithImage:_imageArray[index]];
    
    return photo;
}


@end
