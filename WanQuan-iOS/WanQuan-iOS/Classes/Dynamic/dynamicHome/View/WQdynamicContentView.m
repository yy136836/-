//
//  WQdynamicContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQdynamicContentView.h"
#import "WQmoment_statusModel.h"
#import "WQPhotoBrowser.h"
#import "WQdynamicPicCollectionViewCell.h"


#define ITEM_WIDTH_OR_HEIGHT ((int)((kScreenWidth - 10  - 15 - 15) / 3))
#define ITEM_SPACE (5.0)
static NSString *identifier = @"identifier";

@interface WQdynamicContentView () <UICollectionViewDelegate, UICollectionViewDataSource,MWPhotoBrowserDelegate>

@property (strong, nonatomic) MASConstraint *bottomCon;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;

@end





@implementation WQdynamicContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    [self.collectionView reloadData];
}

#pragma mark -- 点击文字
- (void)contentLabelClick {
    if (self.wqContentLabelClickBlock) {
        self.wqContentLabelClickBlock();
    }
}

#pragma mark - 初始化View
- (void)setupView {
    // 内容
    YYLabel *contentLabel = [[YYLabel alloc] init];
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 6;
    contentLabel.preferredMaxLayoutWidth = kScaleY(kScreenWidth - 10 * 2);
    contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *contentLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLabelClick)];
    [contentLabel addGestureRecognizer:contentLabelTap];
    contentLabel.textColor = [UIColor colorWithHex:0x333333];
    contentLabel.font = [UIFont systemFontOfSize:16];
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:@""];
    text.yy_lineSpacing = 5;
    text.yy_font = [UIFont systemFontOfSize:16];
    contentLabel.attributedText = text;
    [self addSubview:contentLabel];
//    CGSize size = [contentLabel sizeThatFits:CGSizeMake(kScreenWidth - 15 * 2, MAXFLOAT)];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(ghSpacingOfshiwu);
//        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
//        make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
//        make.height.equalTo(@(size.height));
//    }];
    
   
    
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    self.layOut = layOut;
    // 设置item的大小
    layOut.itemSize = CGSizeMake(ITEM_WIDTH_OR_HEIGHT, ITEM_WIDTH_OR_HEIGHT);
    
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = 5;
    layOut.minimumInteritemSpacing = 5;
    // 设置布局方式
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    self.collectionView = collectionView;
    [collectionView registerClass:[WQdynamicPicCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
//        make.right.left.equalTo(contentLabel);
//        make.height.offset(0);
//        make.bottom.equalTo(self);
//    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 0;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
    [imageView addGestureRecognizer:imageTap];
    [self addSubview:imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.collectionView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
//        make.left.equalTo(self.collectionView);
//        make.bottom.equalTo(self);
//        make.width.offset(240);
//        make.height.offset(200);
//    }];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.bottomCon = make.bottom.equalTo(imageView.mas_bottom);
//    }];
}

- (void)setModel:(WQmoment_statusModel *)model {
    _model = model;

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.content];
    text.yy_lineSpacing = 5;
    text.yy_font = [UIFont systemFontOfSize:16];
    text.yy_color = HEX(0x333333);
    self.contentLabel.attributedText = text;
    // 有图片
    if (model.pic.count > 0) {
        if (model.pic.count == 1) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            self.picArray = model.pic;
            self.collectionView.hidden = YES;
            self.imageView.hidden = NO;
            [self.imageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(model.pic.lastObject)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
            
            
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];

            
           
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.left.equalTo(self.contentLabel);
                make.bottom.equalTo(self);
                make.width.offset(245);
                make.height.offset(200);
            }];

            
            if (!model.content.length) {
                [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
                
            }

            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.imageView.mas_bottom);
            }];
            return;
        }
        if (model.pic.count == 2 || model.pic.count == 3) {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
            self.picArray = model.pic;
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
                make.height.offset(0);
            }];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];
            
          
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT*3+2*ITEM_SPACE,ITEM_WIDTH_OR_HEIGHT));
                make.left.equalTo(@15);
            }];
            
            if (!model.content.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
                
            }

            
            
            
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom);
            }];
        }else if (model.pic.count == 4 || model.pic.count == 5 || model.pic.count == 6) {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
            self.picArray = model.pic;
          
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
                make.height.offset(0);
            }];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];
            
            if (model.pic.count ==4) {
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT * 2 + ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT * 2 + ITEM_SPACE));
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                    make.left.equalTo(@15);
                }];
            }else{//5  6
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT * 3 + 2*ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT * 2 + ITEM_SPACE));
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                    make.left.equalTo(@15);
                }];
            }
            
            if (!model.content.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];

            }
            
            
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom);
            }];
        }else {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
            self.picArray = model.pic;
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
                make.height.offset(0);
            }];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];
            
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT * 3 + 2*ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT * 3 + 2*ITEM_SPACE));
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.left.equalTo(@15);
                make.right.equalTo(@(-15));
            }];

            
            if (!model.content.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
                
            }

            
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom);
            }];
        }
    }else {
        self.imageView.hidden = YES;
        self.collectionView.hidden = YES;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ghSpacingOfshiwu);
            make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            make.bottom.equalTo(self);
        }];
        // 没有图片
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom);
        }];
    }
}

// 已经确认好了位置
// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
- (void)layoutSubviews {
    [super layoutSubviews];
    // 必须在 [super layoutSubviews] 调用之后，Label的frame有值之后设置preferredMaxLayoutWidth
    self.contentLabel.preferredMaxLayoutWidth = kScaleY(kScreenWidth - 10 * 2);
    // 设置preferredLayoutWidth后，需要重新布局
    [super layoutSubviews];
}

#pragma mark -- 单张图片的响应事件
- (void)imageViewClick {
    WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser.alwaysShowControls = NO;
    browser.displayActionButton = NO;
    browser.shouldTapBack = YES;
    browser.shouldHideNavBar = YES;
    browser.shouldSave = YES;
    [self.viewController.navigationController pushViewController:browser animated:YES];
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView.collectionViewLayout invalidateLayout];
    return _picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQdynamicPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.picImageview = cell.picImageview;
    cell.imageId = _picArray[indexPath.item];
    [cell setImageClickBlock:^{
        WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
        browser.currentPhotoIndex = indexPath.row;
        browser.alwaysShowControls = NO;
        browser.displayActionButton = NO;
        browser.shouldTapBack = YES;
        browser.shouldHideNavBar = YES;
        browser.shouldSave = YES;
        [self.viewController.navigationController pushViewController:browser
                                                            animated:YES];
    }];
    
    return cell;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL *url = [NSURL URLWithString:[imageUrlString stringByAppendingString:_picArray[index]]];
    MWPhoto *photo = [MWPhoto photoWithURL:url];
    
    return photo;
}

@end
