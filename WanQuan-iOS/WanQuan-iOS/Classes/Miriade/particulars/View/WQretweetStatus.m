//
//  WQretweetStatus.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/22.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQretweetStatus.h"
#import "YYLabel.h"
#import "WQStatusPictureView.h"
#import "WQparticularsModel.h"
#import "CLImageScrollDisplayView.h"
#import "WQPhotoBrowser.h"

@interface WQretweetStatus()<MWPhotoBrowserDelegate>
@property (strong, nonatomic) MASConstraint *bottomCon;
@property (nonatomic, strong) UIImageView *picImageView;
@end

@implementation WQretweetStatus

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化
- (void)setupUI
{
    self.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:1];
    // 内容label
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHex:0x111111];
    contentLabel.text = @"";
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghSpacingOfshiwu;
    [self addSubview:contentLabel];

//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.textColor = [UIColor colorWithHex:0x111111];
//    contentLabel.text = @"";
//    contentLabel.font = [UIFont systemFontOfSize:17];
//    contentLabel.numberOfLines = 0;
//    contentLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghSpacingOfshiwu;
//    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    [self addSubview:self.statusPictureView];
    
    [self addSubview:self.picImageView];
    // 自动布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghStatusCellMargin);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    [_statusPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(contentLabel);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(_statusPictureView.mas_bottom).offset(ghStatusCellMargin);
    }];

}

// 已经确认好了位置
// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    // 你必须在 [super layoutSubviews] 调用之后，longLabel的frame有值之后设置preferredMaxLayoutWidth
//    self.contentLabel.preferredMaxLayoutWidth = self.frame.size.width-100;
//    // 设置preferredLayoutWidth后，需要重新布局
//    [super layoutSubviews];
//}

- (void)setPicArray:(NSArray *)picArray
{
    _picArray = picArray;
    [self.bottomCon uninstall];
    
    if (picArray.count == 1 && picArray.count <= 1) {
        self.statusPictureView.hidden = true;
        self.picImageView.hidden = NO;
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(245);
            make.height.offset(200);
            make.left.equalTo(self.contentLabel.mas_left);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.picImageView.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(picArray.firstObject)] placeholder:[UIImage imageNamed:@"zhanweituda"]];
        return;
    }else{
        self.picImageView.hidden = YES;
    }
    
    if (_picArray.count > 0) {
        self.statusPictureView.hidden = false;
        self.statusPictureView.pic_urls = picArray;

            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.statusPictureView.mas_bottom).offset(ghStatusCellMargin);
            }];
        }else {
            self.statusPictureView.hidden = true;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom);
            }];
    }
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap{
//    CGRect cellFrame = [tap.view convertRect:self.picImageView.frame toView:[UIApplication sharedApplication].keyWindow];
//    CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:0 willShowImageUrls:self.picArray];
//    imageShowView.showPageControl = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
    WQPhotoBrowser * photoBrowser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser .currentPhotoIndex = 0;
    photoBrowser.alwaysShowControls = NO;
    
    photoBrowser.displayActionButton = NO;
    
    photoBrowser.shouldTapBack = YES;
    
    photoBrowser.shouldHideNavBar = YES;

    [self.viewController.navigationController pushViewController:photoBrowser animated:YES];
}

#pragma mark - 懒加载
- (WQStatusPictureView *)statusPictureView
{
    if (!_statusPictureView) {
        _statusPictureView = [[WQStatusPictureView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    return _statusPictureView;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView = [[UIImageView alloc] init];
        _picImageView.userInteractionEnabled = YES;
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.layer.masksToBounds = YES;
        _picImageView.layer.cornerRadius = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_picImageView addGestureRecognizer:tap];
    }
    return _picImageView;
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
