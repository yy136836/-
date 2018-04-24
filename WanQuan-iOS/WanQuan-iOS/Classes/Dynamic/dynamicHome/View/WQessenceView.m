//
//  WQessenceView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQessenceView.h"
#import "WQmoment_choicest_articleModel.h"

@interface WQessenceView ()

@property (strong, nonatomic) MASConstraint *bottomCon;

/**
 精选标题
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 精选图片
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 精选摘要
 */
@property (nonatomic, strong) UILabel *abstractLabel;

// 来自....的图
@property (nonatomic, strong) UIImageView *textImageView;

/**
 来自圈子
 */
@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation WQessenceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    // 精选标题
    UILabel *contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.contentLabel = contentLabel;
    contentLabel.attributedText = [self getAttributedStringWithString:@"精选精选精选精选精选标题精选标题精选标题精选标题精选标题精选标题精选标题精选标题" lineSpace:5];
    contentLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    contentLabel.numberOfLines = 2;
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.left.equalTo(self).offset(kScaleY(ghSpacingOfshiwu));
        make.right.equalTo(self).offset(kScaleY(-ghSpacingOfshiwu));
    }];
    
    // 精选图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 0;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.right.equalTo(contentLabel);
        make.height.offset(kScaleX(150));
    }];
    
    // 精选摘要
    UILabel *abstractLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x777777] andFontSize:15];
    self.abstractLabel = abstractLabel;
    abstractLabel.numberOfLines = 0;
    abstractLabel.attributedText = [self getAttributedStringWithString:@"精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要精选摘要" lineSpace:5];
    [self addSubview:abstractLabel];
    [abstractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentLabel);
        make.top.equalTo(imageView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 来自....
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"laiziquanzi"]];
    self.textImageView = textImageView;
    [self addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(abstractLabel.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(abstractLabel);
        make.bottom.equalTo(self);
    }];
    YYLabel *textLabel = [YYLabel new];
    self.textLabel = textLabel;
    textLabel.userInteractionEnabled = YES;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textImageView);
        make.left.equalTo(textImageView.mas_right).offset(2);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(textImageView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
}

- (void)setModel:(WQmoment_choicest_articleModel *)model {
    _model = model;
    
    // 精选标题
    self.contentLabel.text = model.subject;
    // 精选图片
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_HUGE_URLSTRING(model.cover_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    // 精选摘要
    self.abstractLabel.text = model.desc;
    
    // 精选是否来自圈子
    if (model.article_from_group) {
        self.textImageView.hidden = NO;
        self.textLabel.hidden = NO;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"来自圈子: "
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[self.group_name stringByAppendingString:@">"]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x3b7adb]}]];
        str.yy_font = [UIFont systemFontOfSize:14];
        __weak typeof(self) weakSelf = self;
        [self.textLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.groupNameClickBlock) {
                weakSelf.groupNameClickBlock();
            }
        }];
        self.textLabel.attributedText = str;  //设置富文本
        [self.abstractLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentLabel);
            make.top.equalTo(self.imageView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        [self.textImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.abstractLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.equalTo(self.abstractLabel);
            make.bottom.equalTo(self);
        }];
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.textImageView);
            make.left.equalTo(self.textImageView.mas_right).offset(2);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.textImageView.mas_bottom);
        }];
    }else {
        self.textImageView.hidden = YES;
        self.textLabel.hidden = YES;
        [self.textImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.abstractLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentLabel);
            make.top.equalTo(self.imageView.mas_bottom).offset(ghSpacingOfshiwu);
            make.bottom.equalTo(self);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.abstractLabel.mas_bottom);
        }];
    }
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
