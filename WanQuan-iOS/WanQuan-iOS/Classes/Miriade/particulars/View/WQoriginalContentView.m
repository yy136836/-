//
//  WQoriginalContentView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQoriginalContentView.h"
#import "WQStatusPictureView.h"
#import "WQsourceMomentStatusModel.h"
#import "WQparticularsModel.h"
#import "WQLinksContentView.h"
#import "CLImageScrollDisplayView.h"

@interface WQoriginalContentView()
@property (nonatomic, strong) WQStatusPictureView *statusPictureView;
@property (nonatomic, strong) MASConstraint *bottomCon;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) NSArray *picArray;
@end

@implementation WQoriginalContentView {
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
    self.backgroundColor = [UIColor colorWithHex:0xededed];
    // 内容label
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHex:0x111111];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghSpacingOfshiwu;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    [self addSubview:self.statusPictureView];
    //[self addSubview:self.timeLabel];
    [self addSubview:self.picImageView];
    
    // 自动布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghStatusCellMargin);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    
    [_statusPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(ghStatusCellMargin);
        make.left.equalTo(contentLabel);
    }];
    
    /*[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusPictureView.mas_left);
        make.top.equalTo(_statusPictureView.mas_bottom).offset(ghStatusCellMargin);
    }];*/
    
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
        self.bottomCon = make.bottom.equalTo(_statusPictureView.mas_bottom).offset(ghStatusCellMargin);
    }];
}

// 已经确认好了位置
// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
- (void)layoutSubviews {
    [super layoutSubviews];
    // 你必须在 [super layoutSubviews] 调用之后，longLabel的frame有值之后设置preferredMaxLayoutWidth
    self.contentLabel.preferredMaxLayoutWidth = kScreenWidth - 2 * (CGFloat)ghSpacingOfshiwu;;
    // 设置preferredLayoutWidth后，需要重新布局
    [super layoutSubviews];
}

- (void)setModel:(WQsourceMomentStatusModel *)model {
    _model = model;
    
    NSString *originalName = [@"@" stringByAppendingString:[NSString stringWithFormat:@"%@",[model.user_name stringByAppendingString:@": "]]];
    
    
    NSString *nameAddcontent = [originalName stringByAppendingString:[NSString stringWithFormat:@"%@",model.content]];
    
    NSMutableAttributedString *text= [[NSMutableAttributedString alloc] initWithString:nameAddcontent];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x5d2a89] range:NSMakeRange(0, originalName.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, nameAddcontent.length)];
    _contentLabel.attributedText = text;
    
    self.picArray = model.pic;
    [self.bottomCon uninstall];
    
    // 没有链接
    if ([model.link_txt isEqualToString:@""]) {
        linksContentView.hidden = YES;
        if (self.picArray.count == 1 && self.picArray.count <= 1) {
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
            
            NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",self.picArray.firstObject]];
            [self.picImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
            
            return;
        }else{
            self.picImageView.hidden = YES;
        }
        
        if (self.picArray.count > 0) {
            _statusPictureView.pic_urls = model.pic;
            self.statusPictureView.hidden = false;
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(_statusPictureView.mas_bottom).mas_offset(ghStatusCellMargin);
            }];
        }else {
            self.statusPictureView.hidden = true;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).mas_offset(ghStatusCellMargin);
            }];
        }
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

- (void)setIsDeleteOriginalContent:(BOOL)isDeleteOriginalContent {
    _isDeleteOriginalContent = isDeleteOriginalContent;
    
    if (isDeleteOriginalContent) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        linksContentView.hidden = YES;
    }
}

#pragma mark -- 外链的响应事件
- (void)linksContentViewClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(wqLinksContentViewClick:linkURLString:)]) {
        [self.delegate wqLinksContentViewClick:self linkURLString:_model.link_img];
    }
}

- (void)setParticularsModel:(WQparticularsModel *)particularsModel {
    _particularsModel = particularsModel;

    NSInteger time = particularsModel.past_second;
    if (time < 60) {
        _timeLabel.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        _timeLabel.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
}

- (void)handleTapGes:(UITapGestureRecognizer *)tap {
    CGRect cellFrame = [tap.view convertRect:self.picImageView.frame toView:[UIApplication sharedApplication].keyWindow];
    CLImageScrollDisplayView *imageShowView = [[CLImageScrollDisplayView alloc] initWithConverFrame:cellFrame index:0 willShowImageUrls:self.picArray];
    imageShowView.showPageControl = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:imageShowView];
}

#pragma mark - 懒加载
- (WQStatusPictureView *)statusPictureView {
    if (!_statusPictureView) {
        _statusPictureView = [[WQStatusPictureView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    return _statusPictureView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHex:0X8a8a8a];
    }
    return _timeLabel;
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

@end
