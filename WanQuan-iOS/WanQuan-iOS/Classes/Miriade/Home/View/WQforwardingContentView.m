//
//  WQforwardingContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/25.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <YYLabel.h>
#import "WQforwardingContentView.h"
#import "WQretransmissionModel.h"
#import "WQStatusPictureView.h"
#import "CLImageScrollDisplayView.h"
#import "WQPhotoBrowser.h"
#import "WQLinksContentView.h"

@interface WQforwardingContentView()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) MASConstraint *bottomCon;
@property (nonatomic, strong) WQStatusPictureView *statusPictureView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) NSArray *picArray;
@end

@implementation WQforwardingContentView {
    WQLinksContentView *linksContentView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- 初始化
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHex:0Xefeff4];

    // 内容label
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHex:0x111111];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 6;
    contentLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghStatusCellMargin;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    [self addSubview:self.statusPictureView];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghStatusCellMargin);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    
    [self addSubview:self.picImageView];
    
    [_statusPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(contentLabel);
    }];
    
    linksContentView = [[WQLinksContentView alloc] init];
    linksContentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *linksContentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linksContentViewClick:)];
    [linksContentView addGestureRecognizer:linksContentViewTap];
    linksContentView.isWanquanHome = YES;
    [self addSubview:linksContentView];
    [linksContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusPictureView.mas_bottom);
        make.height.offset(60);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(linksContentView.mas_bottom).mas_offset(ghStatusCellMargin);
    }];
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick:(UITapGestureRecognizer *)tap {
    //[[NSNotificationCenter defaultCenter] postNotificationName:WQlinksContentViewClick object:self userInfo:nil];
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:linkURLString:)]) {
        [self.delegate wqLinksContentViewClick:self linkURLString:_model.link_url];
    }
}

- (void)setModel:(WQretransmissionModel *)model {
    _model = model;
    
//    if (self.isGroupForwarding) {
//        return;
//    }
    NSString *originalName = [@"@" stringByAppendingString:[model.user_name stringByAppendingString:@": "]];

    
    NSString *nameAddcontent = [originalName stringByAppendingString:model.content];
    
    NSMutableAttributedString *text= [[NSMutableAttributedString alloc] initWithString:nameAddcontent];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x9767d0] range:NSMakeRange(0, originalName.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, nameAddcontent.length)];
    _contentLabel.attributedText = text;
    //_contentLabel.text = nameAddcontent;
    self.picArray = model.pic;
    [self.bottomCon uninstall];
    
    // 没有链接
    if ([model.link_txt isEqualToString:@""]) {
        linksContentView.hidden = YES;
        
        [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        // 没有图片
        if (self.picArray.count == 0) {
            self.picImageView.hidden = YES;
            _statusPictureView.hidden = YES;
            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
            }];
        }else if (self.picArray.count == 1) {
            // 只有一张图
            self.picImageView.hidden = NO;
            _statusPictureView.hidden = YES;
            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(245);
                make.height.offset(200);
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
            }];
            
            NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.picArray.firstObject]];
            [self.picImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
            
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.picImageView.mas_bottom).offset(ghStatusCellMargin);
            }];
        }else {
            // 图片大于2
            self.picImageView.hidden = YES;
            _statusPictureView.hidden = NO;
            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
                make.top.equalTo(self.contentLabel.mas_bottom);
            }];
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.picImageView.mas_bottom).offset(ghStatusCellMargin);
                make.left.equalTo(self.contentLabel);
                make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
            }];
            
            _statusPictureView.pic_urls = model.pic;
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(_statusPictureView.mas_bottom).offset(ghStatusCellMargin);
            }];
        }
        
//        if (self.picArray.count == 1 && self.picArray.count <= 1) {
//            self.statusPictureView.hidden = true;
//            self.picImageView.hidden = NO;
//            [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.offset(0);
//                make.height.offset(0);
//                make.left.equalTo(self.contentLabel.mas_left);
//                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
//            }];
//            
//            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.offset(245);
//                make.height.offset(200);
//                make.left.equalTo(self.contentLabel.mas_left);
//                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
//            }];
//            
//            
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                self.bottomCon = make.bottom.equalTo(self.picImageView.mas_bottom).offset(ghStatusCellMargin);
//            }];
//            
//            NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.picArray.firstObject]];
//            [self.picImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
//            
//            return;
//        }else{
//            self.picImageView.hidden = YES;
//        }
        
//        if (self.picArray.count > 0) {
//            _statusPictureView.pic_urls = model.pic;
//            self.statusPictureView.hidden = false;
//            
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                self.bottomCon = make.bottom.equalTo(_statusPictureView.mas_bottom).mas_offset(ghStatusCellMargin);
//            }];
//        }else {
//            self.statusPictureView.hidden = true;
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).mas_offset(ghStatusCellMargin);
//            }];
//        }
    }else {
        // 有链接
        linksContentView.hidden = NO;
        
        if ([model.link_img isEqualToString:@""]) {
            linksContentView.linksImage.image = [UIImage imageNamed:@"lianjie占位图"];
        }else {
            [linksContentView.linksImage yy_setImageWithURL:[NSURL URLWithString:model.link_img] placeholder:[UIImage imageNamed:@"lianjie占位图"]];
        }
        linksContentView.linksLabel.text = model.link_txt;
        
        if (self.picArray.count == 1) {
            _statusPictureView.hidden = YES;
            self.picImageView.hidden = NO;
            [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(245);
                make.height.offset(200);
                make.left.equalTo(self.contentLabel.mas_left);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
            }];
            
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            
            [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.picImageView.mas_bottom).offset(ghStatusCellMargin);
                make.height.offset(60);
                make.left.equalTo(self).offset(ghSpacingOfshiwu);
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            }];
            
            NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.picArray.firstObject]];
            [self.picImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
            
        }
        if (self.picArray.count > 1) {
            _statusPictureView.hidden = NO;
            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
                make.left.equalTo(self.contentLabel);
                make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
            }];
            [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_statusPictureView.mas_bottom).offset(ghStatusCellMargin);
                make.height.offset(60);
                make.left.equalTo(self).offset(ghSpacingOfshiwu);
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            }];
            
            _statusPictureView.pic_urls = model.pic;
            
        }
        
        if (self.picArray.count <= 0) {
            [self.picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [_statusPictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [linksContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
                make.height.offset(60);
                make.left.equalTo(self).offset(ghSpacingOfshiwu);
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            }];
        }
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(linksContentView.mas_bottom).mas_offset(ghStatusCellMargin);
        }];
    }

}

//- (void)setIsGroupForwarding:(BOOL)isGroupForwarding {
//    if (isGroupForwarding) {
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            self.bottomCon = make.bottom.equalTo(self.mas_top).mas_offset(ghStatusCellMargin);
//        }];
//    }
//}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    CGRect cellFrame = [tap.view convertRect:self.picImageView.frame toView:[UIApplication sharedApplication].keyWindow];
//    CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:0 willShowImageUrls:self.picArray];
//    imageShowView.showPageControl = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser .currentPhotoIndex = 0;
    browser.alwaysShowControls = NO;
    
    browser.displayActionButton = NO;
    
    browser.shouldTapBack = YES;
    
    browser.shouldHideNavBar = YES;
    [self.viewController.navigationController pushViewController:browser animated:YES];
}

#pragma mark - 懒加载
- (WQStatusPictureView *)statusPictureView {
    if (!_statusPictureView) {
        _statusPictureView = [[WQStatusPictureView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    return _statusPictureView;
}
- (UIImageView *)picImageView {
    if (!_picImageView) {
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

- (NSArray *)picArray {
    if (!_picArray) {
        _picArray = [[NSArray alloc] init];
    }
    return _picArray;
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
