//
//  WQStatusPictureView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/16.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQStatusPictureView.h"
#import "WQMiriadeaModel.h"
#import "WQStatusPictureViewCell.h"
#import "YYPhotoBrowseView.h"
#import "CLImageScrollDisplayView.h"
#import "WQPhotoBrowser.h"

#define TAG_IMAGE_INDEX 10000

static NSString *pictureCell = @"pictureCell";

@interface WQStatusPictureView() <UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>

@end

@implementation WQStatusPictureView

- (void)setPic_urls:(NSArray *)pic_urls {
    _pic_urls = pic_urls;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcSizeWithCount:pic_urls.count]);
    }];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.delegate = self;
    
    //注册
    [self registerClass:[WQStatusPictureViewCell class] forCellWithReuseIdentifier:pictureCell];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(ghitemWH, ghitemWH);
    layout.minimumLineSpacing = ghitemMargin;
    layout.minimumInteritemSpacing = ghitemMargin;
}

#pragma mark -- 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pic_urls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQStatusPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureCell forIndexPath:indexPath];
    NSLog(@"%@",self.pic_urls);
    cell.picString = self.pic_urls[indexPath.row];
    cell.imageViewArray = self.pic_urls;
    cell.tag = TAG_IMAGE_INDEX + indexPath.row;
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.imageClilcBlock = ^(UIImageView *imageView) {
        CGRect cellFrame = [weakCell convertRect:imageView.frame toView:[UIApplication sharedApplication].keyWindow];
//        CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:indexPath.row willShowImageUrls:self.pic_urls];
//        imageShowView.showPageControl = YES;
//        [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
        
        if (weakCell.viewController.navigationController) {
            WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
            browser .currentPhotoIndex = weakCell.tag - TAG_IMAGE_INDEX;
            browser.alwaysShowControls = NO;
            
            browser.displayActionButton = NO;
            
            browser.shouldTapBack = YES;
            
            browser.shouldHideNavBar = YES;
            [weakCell.viewController.navigationController pushViewController:browser animated:YES];
        }
        
    };
    return cell;
}

#pragma mark -- 设置collectionView的大小
- (CGSize)calcSizeWithCount:(NSInteger)count {
    //列
    NSInteger col = count == 4? 2 : (count > 3? 3 : count);
    //行
    NSInteger row = (count - 1) / 3 + 1;
    //设置collectionView的宽高
    CGFloat width = ghitemWH * (CGFloat)col + ghitemMargin * (CGFloat)(col - 1);
    CGFloat height = ghitemWH * (CGFloat)row + ghitemMargin * (CGFloat)(row - 1);
    // 重新设置每个cell的大小
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(ghitemWH -5, ghitemWH -5);
    CGSize size = CGSizeMake(width , height);
    return size;
}



#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _pic_urls.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:[imageUrlString stringByAppendingString:_pic_urls[index]]];
    
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    return photo;
}

@end
