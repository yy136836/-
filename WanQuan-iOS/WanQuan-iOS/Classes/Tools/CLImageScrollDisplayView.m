//
//  bohe
//
//  Created by 郭杭 on 15/12/16.
//  Copyright © 2015年 WQ. All rights reserved.
//

#import "CLImageScrollDisplayView.h"
#import "CLImageScrollDisplayCell.h"

static NSString *CLImageScrollDisplayCellId = @"CLImageScrollDisplayCellId";
@interface CLImageScrollDisplayView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CLImageScrollDisplayView {
    NSInteger _index;
    CGRect _convertFrame;
    UIImageView *_imageView;
    NSArray<UIImage *> *_imagesArray;
    NSArray<NSString *> *_imageUrls;
    UIButton *_closeBtn;
    UIPageControl *_pageControl;
    CGRect _originalRect;
}

- (instancetype)initWithConverFrame:(CGRect)frame index:(NSInteger)index willShowImages:(NSArray<UIImage *> *)images {
    _index = index;
    _convertFrame = frame;
    _imagesArray = images;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
}

- (instancetype)initWithConverFrame:(CGRect)frame index:(NSInteger)index willShowImageUrls:(NSArray<NSString *> *)imagesUrls {
    _index = index;
    _convertFrame = frame;
    _imageUrls = imagesUrls;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [self initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.pagingEnabled = YES;
    self.frame = [UIScreen mainScreen].bounds;
    [self registerClass:[CLImageScrollDisplayCell class] forCellWithReuseIdentifier:CLImageScrollDisplayCellId];
    self.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
     
    });
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (self.showPageControl) {
        self.delegate = self;
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        pageControl.currentPage = _index;
        if (_imagesArray) {
            pageControl.numberOfPages = _imagesArray.count;
        }else {
            pageControl.numberOfPages = _imageUrls.count;
        }
        pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor?:[UIColor darkGrayColor];
        pageControl.pageIndicatorTintColor = self.pageIndicatorColor?:[UIColor whiteColor];
        [self addSubview:pageControl];
        [self bringSubviewToFront:pageControl];
        pageControl.center = self.center;
        CGRect rect = pageControl.frame;
        rect.origin.y = self.bounds.size.height - rect.size.height - 30;
        pageControl.frame = rect;
        _originalRect = rect;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rect = _pageControl.frame;
    rect.origin.x = scrollView.contentOffset.x + _originalRect.origin.x;
    _pageControl.frame = rect;
    
    CGFloat tempPage = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    NSInteger page = tempPage;
    _pageControl.currentPage = page;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_imagesArray.count > 0) {
        return _imagesArray.count;
    }
    return _imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLImageScrollDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CLImageScrollDisplayCellId forIndexPath:indexPath];
    cell.closeBtnClick = ^{
        NSLog(@"%@", indexPath);
        [self removeFromSuperview];
    };
    if (indexPath.row == _index) {
        cell.convertFrame = _convertFrame;
    }
    if (_imagesArray) {
        cell.displayImage = _imagesArray[indexPath.row];
    }else {
        cell.imageUrl= _imageUrls[indexPath.row];
    }
    return cell;
}

@end
