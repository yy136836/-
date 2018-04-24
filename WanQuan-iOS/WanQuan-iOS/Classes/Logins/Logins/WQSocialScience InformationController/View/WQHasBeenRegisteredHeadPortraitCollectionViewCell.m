//
//  WQHasBeenRegisteredHeadPortraitCollectionViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/9/27.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHasBeenRegisteredHeadPortraitCollectionViewCell.h"
#import "WQHasJoinedWanQuanModel.h"
#import "WQNoneOfTheAboveModel.h"

@implementation WQHasBeenRegisteredHeadPortraitCollectionViewCell {
    // 头像
    UIImageView *headPortraitImageView;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpContentView];
    }
    return self;
}

- (void)setUpContentView {
    headPortraitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu"]];
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitImageView.layer.cornerRadius = kScaleX(12.5);
    headPortraitImageView.clipsToBounds = YES;
    headPortraitImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:headPortraitImageView];
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(WQHasJoinedWanQuanModel *)model {
    _model = model;
    
    [headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
}

- (void)setNoneOfTheAboveModel:(WQNoneOfTheAboveModel *)noneOfTheAboveModel {
    _noneOfTheAboveModel = noneOfTheAboveModel;
    
    [headPortraitImageView yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(noneOfTheAboveModel.user_pic)] placeholder:[UIImage imageNamed:@"zhanweitu"]];
}

@end
