//
//  WQDynamicDetailsContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQDynamicDetailsContentView.h"
#import "WQdynamicPicCollectionViewCell.h"
#import "WQPhotoBrowser.h"
#import "WQTopicArticleController.h"

#define ITEM_WIDTH_OR_HEIGHT (int)((kScreenWidth - 10  - 15 - 15) / 3)
#define ITEM_SPACE (5.0)

static NSString *identifier = @"identifier";

@interface WQDynamicDetailsContentView () <UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>

@property (strong, nonatomic) MASConstraint *bottomCon;

@end

@implementation WQDynamicDetailsContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// 已经确认好了位置
// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    // 必须在 [super layoutSubviews] 调用之后，contentLabel的frame有值之后设置preferredMaxLayoutWidth
//    self.contentLabel.preferredMaxLayoutWidth = kScaleY(kScreenWidth - 5 * 2);
//    // 设置preferredLayoutWidth后，需要重新布局
//    [super layoutSubviews];
//}

#pragma mark - 初始化View
- (void)setupView {
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.isCopyable = true;
    self.contentLabel = contentLabel;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的大小
    layOut.itemSize = CGSizeMake(ITEM_WIDTH_OR_HEIGHT,ITEM_WIDTH_OR_HEIGHT);
    layOut.minimumLineSpacing = 5;
    layOut.minimumInteritemSpacing = 5;
    // 设置布局方式
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置距离上 左 下 右
    // layOut.sectionInset = UIEdgeInsetsMake(0, 0,0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    self.collectionView = collectionView;
    [collectionView registerClass:[WQdynamicPicCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.right.mas_equalTo(15);
        make.height.offset(0);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 0;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
    [imageView addGestureRecognizer:imageTap];
    [self addSubview:imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
        make.left.equalTo(self.collectionView);
        make.bottom.equalTo(self);
        make.width.offset(240);
        make.height.offset(200);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(imageView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

- (void)imageViewClick {
    WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser.alwaysShowControls = NO;
    browser.displayActionButton = NO;
    browser.shouldTapBack = YES;
    browser.shouldHideNavBar = YES;
    browser.shouldSave = YES;
    [self.viewController.navigationController pushViewController:browser animated:YES];
}

- (void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    
    // 识别链接
    [self.contentLabel setTextWithLinkAttribute:self.contentString];
    
    // 链接的响应事件
    [self.contentLabel yb_addAttributeTapActionWithStrings:self.contentLabel.linkArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        //        NSLog(@"%@",string);
        NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
        NSLog(@"%@",message);
        WQTopicArticleController * vc = [[WQTopicArticleController alloc] init];
        vc.URLString = string;
        vc.NavTitle = @"";
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }];
    
    // 有图片
    if (picArray.count > 0) {
        if (picArray.count == 1) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            self.collectionView.hidden = YES;
            self.imageView.hidden = NO;
            [self.imageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(picArray.lastObject)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.left.equalTo(self.contentLabel);
                make.bottom.equalTo(self);
                make.width.offset(240);
                make.height.offset(200);
            }];
            
            if (!self.contentString.length) {
                [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
            }
            
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.imageView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
            return;
        }
        if (picArray.count == 2 || picArray.count == 3) {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
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
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT *3 + 2*ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT));

            }];
            
            if (!self.contentString.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
            }

            [self.collectionView reloadData];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }else if (picArray.count == 4 || picArray.count == 5 || picArray.count == 6) {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
            
            
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
                make.height.offset(0);
            }];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(ghSpacingOfshiwu);
                make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
                make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
            }];
            
            if (picArray.count ==4) {
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT *2 +ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT * 2 + ITEM_SPACE));
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                    make.left.equalTo(@15);
                }];
            }else{// 5  6
                [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT *3 + 2*ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT * 2 + ITEM_SPACE));
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                    make.left.equalTo(@15);
                }];

            }

            if (!self.contentString.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
            }
            [self.collectionView reloadData];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
            }];
        }else {
            self.imageView.hidden = YES;
            self.collectionView.hidden = NO;
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
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(ITEM_WIDTH_OR_HEIGHT *3 + 2*ITEM_SPACE, ITEM_WIDTH_OR_HEIGHT *3 + 2*ITEM_SPACE));
            }];
            if (!self.contentString.length) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(ghSpacingOfshiwu);
                }];
            }
            [self.collectionView reloadData];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.collectionView.mas_bottom).offset(ghSpacingOfshiwu);
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
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(ghSpacingOfshiwu);
        }];
    }
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQdynamicPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.picImageview = cell.picImageview;
    [cell.picImageview yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_LARGE_URLSTRING(_picArray[indexPath.item])] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    
    [cell setImageClickBlock:^{
        WQPhotoBrowser *browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
        browser.currentPhotoIndex = indexPath.row;
        browser.alwaysShowControls = NO;
        browser.displayActionButton = NO;
        browser.shouldTapBack = YES;
        browser.shouldHideNavBar = YES;
        browser.shouldSave = YES;
        [self.viewController.navigationController pushViewController:browser animated:YES];
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

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    
    if (!string.length) {
        return [NSAttributedString new];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
