//
//  WQHasBeenRegisteredTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/10/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQHasBeenRegisteredTableViewCell.h"
#import "WQHasJoinedWanQuanModel.h"
#import "WQHasJoinedWanQuanWorkModel.h"
#import "WQHasJoinedWanQuanEducationModel.h"
#import "WQNoneOfTheAboveModel.h"

@interface WQHasBeenRegisteredTableViewCell ()

/**
 头像
 */
@property (nonatomic, strong) UIImageView *user_pic;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 工作经历标签
 */
@property (nonatomic, strong) UILabel *workExperienceLabel;

/**
 学习经历标签
 */
@property (nonatomic, strong) UILabel *learningExperienceLabel;

@end

@implementation WQHasBeenRegisteredTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 顶部分割线
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
    // 头像
    self.user_pic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouyewode"]];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.layer.cornerRadius = 25;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.userInteractionEnabled = YES;
    [self.contentView addSubview:self.user_pic];
    [self.user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    // 姓名
    self.nameLabel = [UILabel labelWithText:@"姓名" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kScaleX(ghStatusCellMargin));
        make.left.equalTo(self.user_pic.mas_right).offset(kScaleX(ghStatusCellMargin));
    }];
    
    // 工作经历标签
    self.workExperienceLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
    [self.contentView addSubview:self.workExperienceLabel];
    [self.workExperienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kScaleX(4));
    }];
    
    // 学习经历标签
    self.learningExperienceLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:13];
    [self.contentView addSubview:self.learningExperienceLabel];
    [self.learningExperienceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workExperienceLabel.mas_left);
        make.top.equalTo(self.workExperienceLabel.mas_bottom).offset(kScaleX(4));
    }];
    
    // 已认证的view
    UILabel *textLabel = [UILabel labelWithText:@" 已认证" andTextColor:[UIColor colorWithHex:0x9872ca] andFontSize:11];
    textLabel.backgroundColor = [UIColor colorWithHex:0xf4f0ff];
    [self.contentView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.left.equalTo(self.nameLabel.mas_right).offset(kScaleY(2));
        make.size.mas_equalTo(CGSizeMake((42), kScaleX(16)));
    }];
}

- (void)setNoneOfTheAboveModel:(WQNoneOfTheAboveModel *)noneOfTheAboveModel {
    _noneOfTheAboveModel = noneOfTheAboveModel;
    
    self.nameLabel.text = noneOfTheAboveModel.user_name;

    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(noneOfTheAboveModel.user_pic)] placeholder:[UIImage imageNamed:@"shouyewode"]];
    switch (noneOfTheAboveModel.user_tag.count) {
        case 0: {
            self.learningExperienceLabel.hidden = YES;
            self.workExperienceLabel.hidden = YES;
            [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.user_pic.mas_centerY);
                make.left.equalTo(self.user_pic.mas_right).offset(kScaleX(ghStatusCellMargin));
            }];
        }
            break;
        case 1: {
            self.learningExperienceLabel.hidden = YES;
            self.workExperienceLabel.hidden = NO;
            self.workExperienceLabel.text = noneOfTheAboveModel.user_tag.lastObject;
            [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(kScaleX(ghStatusCellMargin));
                make.left.equalTo(self.user_pic.mas_right).offset(kScaleY(ghStatusCellMargin));
            }];
        }
            break;
        case 2: {
            self.learningExperienceLabel.hidden = NO;
            self.workExperienceLabel.hidden = NO;
            self.workExperienceLabel.text = noneOfTheAboveModel.user_tag.firstObject;
            self.learningExperienceLabel.text = noneOfTheAboveModel.user_tag.lastObject;
            [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(kScaleX(ghStatusCellMargin));
                make.left.equalTo(self.user_pic.mas_right).offset(kScaleY(ghStatusCellMargin));
            }];
        }
            break;
            
        default: {
            [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(kScaleX(ghStatusCellMargin));
                make.left.equalTo(self.user_pic.mas_right).offset(kScaleY(ghStatusCellMargin));
            }];
        }
            break;
    }
}

- (void)setModel:(WQHasJoinedWanQuanModel *)model {
    _model = model;
    
    self.nameLabel.text = model.user_name;
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] placeholder:[UIImage imageNamed:@"shouyewode"]];
    
    if (model.user_work_experience.count) {
        for (WQHasJoinedWanQuanWorkModel *workModel in model.user_work_experience) {
            self.workExperienceLabel.text = [[workModel.work_enterprise stringByAppendingString:@" "] stringByAppendingString:workModel.work_position];
        }
    }else {
        self.workExperienceLabel.text = model.user_tag.firstObject;
    }
    
    if (model.user_education_experience.count) {
        for (WQHasJoinedWanQuanEducationModel *educationModel in model.user_education_experience) {
            NSString *jieshushijian = [NSString stringWithFormat:@"%@",educationModel.education_end_time.copy];
            NSString *kaishishijian = [NSString stringWithFormat:@"%@",educationModel.education_start_time.copy];
            
            NSString *str1;
            NSString *str2;
            if (kaishishijian.length > 4 && jieshushijian != NULL && jieshushijian.length > 4 && jieshushijian != NULL) {
                str2 = [kaishishijian substringToIndex:4];
                str1 = [jieshushijian substringToIndex:4];
                self.learningExperienceLabel.text = [[[[[[educationModel.education_major stringByAppendingString:@" "] stringByAppendingString:educationModel.education_school] stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat:@"%@",str1]] stringByAppendingString:@"-"] stringByAppendingString:[NSString stringWithFormat:@"%@",str2]];
            }
            
        }
    }else {
        self.learningExperienceLabel.text = model.user_tag.lastObject;
    }
    
}

@end
