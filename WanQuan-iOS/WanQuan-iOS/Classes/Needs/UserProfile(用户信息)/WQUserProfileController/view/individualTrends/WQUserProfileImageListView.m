//
//  WQUserProfileImageListView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileImageListView.h"
#import "WQPhotoBrowser.h"

#define TAG_IMAGE_VIEW 10000

@interface WQUserProfileImageListView()<MWPhotoBrowserDelegate>
@property (nonatomic, retain) NSArray * imageIds;
@property (nonatomic, retain) UILabel * imageCountLabel;
@end

@implementation WQUserProfileImageListView

- (instancetype)initWithImageIds:(NSArray *)imageIds {
    if (!imageIds.count) {
        return nil;
    }
    if (self = [super init]) {
        
        
        for (UIImageView * imageView in self.subviews) {
            if ([imageView isKindOfClass:[UIImageView class]]) {
                [imageView removeFromSuperview];
            }
        }
        self.backgroundColor = [UIColor whiteColor];
        self.imageIds = imageIds;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}


- (void)setImageIds:(NSArray *)imageIds {
    _imageIds = imageIds;
    NSInteger showImageCount = 3;
    UIImageView * lastShowImageView;
    
    if (_imageIds.count <= showImageCount) {
        [_imageCountLabel removeFromSuperview];
        _imageCountLabel = nil;
    }
    
    CGFloat imageHerozenSpace = 10.0;
    for (NSInteger imageIdIndex = 0; imageIdIndex < _imageIds.count;  ++ imageIdIndex) {
        
        if (imageIdIndex < showImageCount) {
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((80 + imageHerozenSpace)  * imageIdIndex, 0, 80, 80)];
            [imageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_MIDDLE_URLSTRING(_imageIds[imageIdIndex])]
                                         placeholder:[UIImage imageWithColor:[UIColor lightGrayColor]]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = imageIdIndex + TAG_IMAGE_VIEW;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageOnTap:)]];
            
            if (imageIdIndex == showImageCount - 1) {
                
                lastShowImageView = imageView;
            }
            [self addSubview:imageView];
        }
    }
    
    if (_imageIds.count > showImageCount && !_imageCountLabel) {
        
        _imageCountLabel = [[UILabel alloc] init];
        [lastShowImageView addSubview:_imageCountLabel];
        [_imageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(@0);
            make.width.equalTo(@30);
            make.right.equalTo(@15);
        }];
        _imageCountLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _imageCountLabel.font = [UIFont systemFontOfSize:9];
        _imageCountLabel.textColor = [UIColor whiteColor];
        _imageCountLabel.textAlignment = NSTextAlignmentCenter;
        _imageCountLabel.text = [NSString stringWithFormat:@"共%ld张",_imageIds.count];
    }
}

- (void)imageOnTap:(UITapGestureRecognizer *)sender {
    UIImageView * imageView = (UIImageView *)(sender.view);
    NSInteger index = imageView.tag - TAG_IMAGE_VIEW;
    
    WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser.alwaysShowControls = NO;
    browser.displayActionButton = NO;
    browser.shouldTapBack = YES;
    browser.shouldHideNavBar = YES;
    [self.viewController.navigationController pushViewController:browser animated:YES];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageIds.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [MWPhoto photoWithURL:[NSURL URLWithString:WEB_IMAGE_URLSTRING(_imageIds[index])]];
}
@end
