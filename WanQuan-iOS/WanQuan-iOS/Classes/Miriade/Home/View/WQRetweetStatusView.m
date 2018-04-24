
//
//  WQRetweetStatusView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/13.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQRetweetStatusView.h"
#import "YYLabel.h"
#import "WQStatusPictureView.h"
#import "YYPhotoBrowseView.h"
#import "CLImageScrollDisplayView.h"
#import "WQPhotoBrowser.h"

@interface WQRetweetStatusView()<MWPhotoBrowserDelegate>
@property (strong, nonatomic) MASConstraint *bottomCon;
@property (strong, nonatomic) WQStatusPictureView *statusPictureView;
@end

@implementation WQRetweetStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
// 已经确认好了位置
//// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    // 你必须在 [super layoutSubviews] 调用之后，longLabel的frame有值之后设置preferredMaxLayoutWidth
//    self.contentLabel.preferredMaxLayoutWidth = kScreenWidth - ghSpacingOfshiwu;
//    // 设置preferredLayoutWidth后，需要重新布局
//    [super layoutSubviews];
//}

#pragma mark -- 初始化
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0xffffff alpha:1];
    self.backgroundColor = [UIColor colorWithHex:0xffffff];
    // 内容label
    //YYLabel *contentLabel = [[YYLabel alloc] init];
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.textColor = [UIColor colorWithHex:0x333333];
//    contentLabel.text = @"111";
//    contentLabel.font = [UIFont systemFontOfSize:16];
//    contentLabel.numberOfLines = 6;
//    contentLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLabelTapGes:)];
//    [contentLabel addGestureRecognizer:tap];
//    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    contentLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
//    //2 * (CGFloat)ghSpacingOfshiwu;
//    [self addSubview:contentLabel];
//    self.contentLabel = contentLabel;
//    
//    // 自动布局
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self).offset(ghSpacingOfshiwu);
//        //make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
//        make.width.offset(kScreenWidth - ghSpacingOfshiwu);
//    }];
    UILabel *contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    contentLabel.numberOfLines = 6;
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    
    [self addSubview:self.picImageView];
    
    WQStatusPictureView *statusPictureView = [[WQStatusPictureView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self addSubview:statusPictureView];
    self.statusPictureView = statusPictureView;
    
    [statusPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(statusPictureView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    self.statusPictureView.pic_urls = picArray;
    [self.bottomCon uninstall];
    if (picArray.count == 1 && picArray.count <= 1) {
        self.statusPictureView.hidden = true;
        self.picImageView.hidden = NO;
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(245);
            make.height.offset(200);
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.picImageView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(picArray.firstObject)] placeholder:[UIImage imageNamed:@"zhanweituda"]];
        return ;
    }else{
        self.picImageView.hidden = YES;
//        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.offset(0);
//            make.height.offset(0);
//            make.left.equalTo(self.contentLabel.mas_left);
//            make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
//        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
        }];
    }
    
    if (picArray.count > 0) {
        self.statusPictureView.hidden = false;
        self.statusPictureView.pic_urls = picArray;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.statusPictureView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }else {
        self.statusPictureView.hidden = true;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }
}

- (void)setIsContent:(BOOL)isContent {
    _isContent = isContent;
    if (isContent) {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
    }else {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.height.offset(0);
        }];
    }
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    CGRect cellFrame = [tap.view convertRect:self.picImageView.frame toView:[UIApplication sharedApplication].keyWindow];
//    CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:0 willShowImageUrls:self.picArray];
//    imageShowView.showPageControl = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
    
    if (self.viewController.navigationController) {
        WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
        browser .currentPhotoIndex = 0;
        browser.alwaysShowControls = NO;
        
        browser.displayActionButton = NO;
        
        browser.shouldTapBack = YES;
        
        browser.shouldHideNavBar = YES;
        [self.viewController.navigationController pushViewController:browser animated:YES];
    }
    
}

// 点击文字
- (void)contentLabelTapGes:(UITapGestureRecognizer *)tap {
    if (self.contentLabelClikeBlock) {
        self.contentLabelClikeBlock();
    }
}

#pragma mark -- 懒加载
- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.userInteractionEnabled = YES;
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.layer.masksToBounds = YES;
        _picImageView.layer.cornerRadius = 0;
        _picImageView.hidden = YES;
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
