//
//  WQThemeImageView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/30.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQThemeImageView.h"
#import "WQThemeImageCollectionViewCell.h"
#import "WQPhotoBrowser.h"

static NSString *cellId = @"1111111";

@interface WQThemeImageView () <UICollectionViewDelegate, UICollectionViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WQThemeImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    [self.collectionView reloadData];
}

- (void)setPic:(NSArray *)pic {
    _pic = pic;
    [self.collectionView reloadData];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ghitemWH, ghitemWH);
    layout.minimumLineSpacing = ghitemMargin;
    // 水平间距
    layout.minimumInteritemSpacing = ghitemMargin;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[WQThemeImageCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-kScaleX(70));
        make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQThemeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    self.cell = cell;
    cell.picImageView.image = nil;
    //NSString *picURL = [imageUrlString stringByAppendingString:self.picArray[indexPath.row]];
    [cell.picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(self.picArray[indexPath.row])] placeholder:[UIImage imageNamed:@"zhanweitu"]];

    if (indexPath.row == 2) {
        // 最后一张图显示图片的总数量
        cell.countLabel.hidden = NO;
        cell.backgroundViewCount.hidden = NO;
        // 总数量
        cell.countLabel.text = [[@"共" stringByAppendingString:[NSString stringWithFormat:@"%zd",_pic.count]] stringByAppendingString:@"张"];
    }else {
        // 前边的图不显示图片的总数量
        cell.countLabel.hidden = YES;
        cell.backgroundViewCount.hidden = YES;
    }
    
    __weak typeof(cell) weakCell = cell;
    // 点击图片
    [cell setImageClilcBlock:^{
        if (weakCell.viewController.navigationController) {
            WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
            browser .currentPhotoIndex = indexPath.row;
            browser.alwaysShowControls = NO;
            browser.displayActionButton = NO;
            browser.shouldTapBack = YES;
            browser.shouldHideNavBar = YES;
            [weakCell.viewController.navigationController pushViewController:browser animated:YES];
        }
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(kScaleX(90), kScaleY(90));
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _pic.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL * url = [NSURL URLWithString:[imageUrlString stringByAppendingString:_pic[index]]];
    MWPhoto * photo = [MWPhoto photoWithURL:url];
    return photo;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
