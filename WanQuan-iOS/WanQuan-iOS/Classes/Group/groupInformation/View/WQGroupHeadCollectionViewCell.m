//
//  WQGroupHeadCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQGroupHeadCollectionViewCell.h"
#import "WQGroupMemberModel.h"

@interface WQGroupHeadCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation WQGroupHeadCollectionViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return self;
}

#pragma mark -- 初始化UI
- (void)setupUI {
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    self.headImageView = headImageView;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.layer.cornerRadius = 22;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.circleMainLabel = [UILabel labelWithText:@"  圈主" andTextColor:[UIColor whiteColor] andFontSize:9];
    self.circleMainLabel.layer.cornerRadius = 2;
    self.circleMainLabel.layer.masksToBounds = YES;
    self.circleMainLabel.backgroundColor = [UIColor colorWithHex:0xf5a623];
    [self.contentView addSubview:self.circleMainLabel];
    [self.circleMainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImageView.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(28, 16));
    }];
    
    self.administratorLabel = [UILabel labelWithText:@"  管理员" andTextColor:[UIColor whiteColor] andFontSize:9];
    self.circleMainLabel.layer.cornerRadius = 2;
    self.circleMainLabel.layer.masksToBounds = YES;
    self.administratorLabel.backgroundColor = [UIColor colorWithHex:0x5288d8];
    [self.contentView addSubview:self.administratorLabel];
    [self.administratorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 16));
        make.centerX.equalTo(headImageView.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(-5);
    }];
}

- (void)setModel:(WQGroupMemberModel *)model {
    _model = model;
    
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
    
    /**
     是否是管理员
     */
    //isAdmin
    
    /**
     是否是群主
     */
    //isOwner
    
    if ([model.isAdmin boolValue]) {
        if ([model.isOwner boolValue]) {
            self.circleMainLabel.hidden = NO;
            self.administratorLabel.hidden = YES;
        }else {
            self.circleMainLabel.hidden = YES;
            self.administratorLabel.hidden = NO;
        }
    }else {
        self.circleMainLabel.hidden = YES;
        self.administratorLabel.hidden = YES;
    }
}

@end
