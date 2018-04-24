//
//  WQorderDetailsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <YYLabel.h>
#import "WQorderDetailsTableViewCell.h"
#import "WQpictureView.h"
#import "CLImageScrollDisplayView.h"
#import "WQHomeNearby.h"
#import "NSString+WQSMScountdown.h"
#import "WQfeedbackViewController.h"
#import "WQPhotoBrowser.h"
#import "WQUserProfileController.h"
#import "WQAlreadyReceiveView.h"

@interface WQorderDetailsTableViewCell()<MWPhotoBrowserDelegate,WQAlreadyReceiveViewDelegate>
// 头像
@property (nonatomic, strong) UIImageView *picImageView;
// 图片
@property (nonatomic, strong) WQpictureView *pictureView;
// 反馈的按钮
@property (nonatomic, strong) UIButton *feedbackBtn;
// 资质的字符Label
@property (nonatomic, strong) UILabel *qualificationLabel;
// 资质上边的一条线
@property (nonatomic, strong) UIView *separatedLineView;
// 约定见面时间下的一条线
@property (nonatomic, strong) UIView *lineView;
// 约定见面地址下的一条线
@property (nonatomic, strong) UIView *bottomLineView;
// 约定的见面地址
@property (nonatomic, strong) UILabel *meetTheAddressLabel;
// 约定的见面时间
@property (nonatomic, strong) UILabel *meetingTimeLabel;
// 观看人数tag
@property (nonatomic, strong) UILabel *watchLabel;
// 从群组的过来的需要显示删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;
// 领取后显示的红包
@property (nonatomic, strong) WQAlreadyReceiveView *alreadyReceiveView;
@end

@implementation WQorderDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isGroup = NO;
        _redEnvelopeImageView.animationImages = nil;
        [_redEnvelopeImageView setAnimationImages:nil];
    }
    return self;
}

- (void)setModel:(WQHomeNearby *)model {
    _model = model;
    
    if ([model.category_level_1  isEqualToString:@"找人"]) {
        [self.contentView addSubview:self.subjectLabel];
        [self.contentView addSubview:self.separatedView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.pictureView];
//        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.feedbackBtn];
        [self.contentView addSubview:self.separatedLineView];
        [self.contentView addSubview:self.qualificationLabel];
        [self.contentView addSubview:self.qualificationContentLabel];
        
//        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
//            make.centerY.equalTo(_subjectLabel.mas_centerY);
//        }];
        [_subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(kScaleY(8));
            make.right.equalTo(self.contentView).offset(kScaleX(-ghStatusCellMargin));
        }];
        [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subjectLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.right.equalTo(self.contentView);
            make.left.equalTo(_subjectLabel.mas_left);
            make.height.offset(0.5);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatedView.mas_bottom).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self.contentView).offset(-15);
        }];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(245);
            make.height.offset(200);
        }];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(260);
            make.height.offset(120);
            //make.bottom.equalTo(self.contentView).offset(-84);
        }];
        
        [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.top.equalTo(_pictureView.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        [_separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_feedbackBtn.titleLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.right.equalTo(self.contentView);
            make.height.offset(ghStatusCellMargin);
        }];
        
        _qualificationLabel.text = @"接单者完成要求:";
        
        [_qualificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.mas_left);
            make.top.equalTo(_separatedLineView.mas_bottom).offset(12);
        }];
        
        [_qualificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualificationLabel.mas_bottom).offset(8);
            make.left.equalTo(_contentLabel.mas_left).offset(-0.1);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
        
        // 从群组过来的需要分割线
        if (self.isGroupManager) {
            // 从群组过来的并且是群主显示删除按钮
//            [self.contentView addSubview:self.deleteBtn];
//            [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_feedbackBtn.mas_centerY);
//                make.right.equalTo(_feedbackBtn.mas_right);
//            }];
        }
    }
    
    if ([model.category_level_1 isEqualToString:@"问事"]) {
        [self.contentView addSubview:self.subjectLabel];
        [self.contentView addSubview:self.separatedView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.pictureView];
//        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.feedbackBtn];
        [self.contentView addSubview:self.separatedLineView];
        [self.contentView addSubview:self.qualificationLabel];
        [self.contentView addSubview:self.qualificationContentLabel];
        
//        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
//            make.centerY.equalTo(_subjectLabel.mas_centerY);
//        }];
        [_subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(kScaleY(8));
            make.right.equalTo(self.contentView).offset(kScaleX(-ghStatusCellMargin));
        }];
        [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subjectLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView);
            make.left.equalTo(_subjectLabel.mas_left);
            make.height.offset(0.5);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatedView.mas_bottom).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self.contentView).offset(-15);
        }];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(245);
            make.height.offset(200);
        }];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(260);
            make.height.offset(120);
        }];
        
        [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.top.equalTo(_pictureView.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        [_separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_feedbackBtn.titleLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.right.equalTo(self.contentView);
            make.height.offset(ghStatusCellMargin);
        }];
        
        [_qualificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.mas_left);
            make.top.equalTo(_separatedLineView.mas_bottom).offset(12);
        }];
        
        [_qualificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualificationLabel.mas_bottom).offset(8);
            make.left.equalTo(_contentLabel.mas_left).offset(-0.1);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
        
        // 从群组过来的需要分割线
        if (self.isGroupManager) {
            // 从群组过来的并且是群主显示删除按钮
//            [self.contentView addSubview:self.deleteBtn];
//            [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_feedbackBtn.mas_centerY);
//                make.right.equalTo(_feedbackBtn.mas_right);
//            }];
        }
    }
    
    if ([model.category_level_1 isEqualToString:@"BBS"]) {
        [self.contentView addSubview:self.subjectLabel];
        [self.contentView addSubview:self.separatedView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.pictureView];
        [self.contentView addSubview:self.feedbackBtn];
        [self.contentView addSubview:self.watchLabel];

        [_subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(kScaleY(8));
            make.right.equalTo(self.contentView).offset(kScaleX(-ghStatusCellMargin));
        }];
        [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subjectLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView);
            make.left.equalTo(_subjectLabel.mas_left);
            make.height.offset(0.5);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatedView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self.contentView).offset(-15);
        }];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(245);
            make.height.offset(200);
        }];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(260);
            make.height.offset(120);
        }];
        [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.top.equalTo(_pictureView.mas_bottom).offset(ghStatusCellMargin);
        }];
        [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_feedbackBtn.titleLabel.mas_top);
            make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        }];
        
        
        UIView *bcakView = [[UIView alloc] init];
        bcakView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bcakView];
        [bcakView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_watchLabel.mas_bottom);
            make.right.left.bottom.equalTo(self.contentView);
        }];
        
        UILabel *moneyLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0xf8e71c] andFontSize:10];
        
        if ([self.model.can_bid boolValue]) {
            self.redEnvelopeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hongbao5"]];
            moneyLabel.hidden = YES;
            [self.redEnvelopeImageView.layer removeAllAnimations];
            NSMutableArray *ary = [NSMutableArray new];
            _redEnvelopeImageView.userInteractionEnabled = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redEnvelopeImageViewClike)];
            [_redEnvelopeImageView addGestureRecognizer:tap];
            for(int i = 0; i < 6; i++){
                //通过for 循环,把我所有的 图片存到数组里面
                NSString *imageName = [NSString stringWithFormat:@"hongbao%d",i];
                UIImage *image = [UIImage imageNamed:imageName];
                [ary addObject:image];
            }
            // 设置图片的序列帧 图片数组
            _redEnvelopeImageView.animationImages = ary;
            // 动画重复次数
            _redEnvelopeImageView.animationRepeatCount = 1;
            // 动画执行时间,多长时间执行完动画
            _redEnvelopeImageView.animationDuration = 5;
            // 开始动画
            [_redEnvelopeImageView startAnimating];
            //[_redEnvelopeImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:5];
            [self performSelector:@selector(endOfThe) withObject:nil afterDelay:5];
        } else {
            self.redEnvelopeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yilingqu"]];
            _redEnvelopeImageView.userInteractionEnabled = NO;
            moneyLabel.hidden = NO;
        }
        [self.contentView addSubview:self.redEnvelopeImageView];
        [self.contentView addSubview:self.redEnvelopeLabel];
        self.redEnvelopeLabel.hidden = NO;
        [_redEnvelopeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_watchLabel.mas_bottom).offset(25);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        [_redEnvelopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.redEnvelopeImageView.mas_bottom).offset(8);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-ghSpacingOfshiwu);
        }];
        
        //self.moneyLabel = moneyLabel;
        [self addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.redEnvelopeImageView.mas_bottom).offset(-20);
        }];
        
        moneyLabel.text = [model.money stringByAppendingString:@"元"];
        
        if (![model.has_bid boolValue]) {
            
            NSInteger time = [[NSString stringWithFormat:@"%@",model.left_secends] integerValue];
            if (time < 0) {
                moneyLabel.hidden = YES;
                _redEnvelopeLabel.text = @"需求已完成";
            }
        }
        
        // 从群组过来的需要分割线
        if (self.isGroup) {
            // 底部的分割线
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = [UIColor colorWithHex:0xededed];
            [self.contentView addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.height.offset(ghStatusCellMargin);
                make.top.equalTo(_redEnvelopeLabel.mas_bottom).offset(15);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }else {
            [_redEnvelopeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_redEnvelopeImageView.mas_centerX);
                make.top.equalTo(_redEnvelopeImageView.mas_bottom).offset(ghStatusCellMargin);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-ghStatusCellMargin * 2);
            }];
        }
        
        // 是自己发的
        if (self.isYourOwn) {
            _redEnvelopeImageView.image = nil;
            moneyLabel.text = @"";
            _redEnvelopeLabel.text = @"";
            [bcakView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            [_feedbackBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-ghSpacingOfshiwu);
                make.top.equalTo(_pictureView.mas_bottom).offset(ghStatusCellMargin);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }
        
        // 从群组过来的需要分割线
        if (self.isGroupManager) {
            // 从群组过来的并且是群主显示删除按钮
//            [self.contentView addSubview:self.deleteBtn];
//            [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_feedbackBtn.mas_centerY);
//                make.right.equalTo(_feedbackBtn.mas_right);
//            }];
        }
        
        NSString *guankanrenshu = @"观看人数: ";
        _watchLabel.text = [guankanrenshu stringByAppendingString:model.view_count];
    }
    
    if ([model.category_level_1 isEqualToString:@"帮忙"]) {
        
        [self.contentView addSubview:self.subjectLabel];
        [self.contentView addSubview:self.separatedView];
        [self.contentView addSubview:self.meetingTimeLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.meetTheAddressLabel];
        [self.contentView addSubview:self.bottomLineView];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.pictureView];
//        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.feedbackBtn];
        [self.contentView addSubview:self.separatedLineView];
        [self.contentView addSubview:self.qualificationLabel];
        [self.contentView addSubview:self.qualificationContentLabel];
        

        

        
        
//        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
//            make.centerY.equalTo(_subjectLabel.mas_centerY);
//        }];
        [_subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(kScaleY(8));
            make.right.equalTo(self.contentView).offset(kScaleX(-ghStatusCellMargin));
        }];
        [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subjectLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView);
            make.left.equalTo(_subjectLabel.mas_left);
            make.height.offset(0.5);
        }];
        

        [_meetingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatedView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_subjectLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
        }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_meetingTimeLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_subjectLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.offset(0.5);
        }];
        

        
        [_meetTheAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_subjectLabel.mas_left);
            make.top.equalTo(_lineView.mas_bottom).offset(ghStatusCellMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
        }];
        
        [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_subjectLabel.mas_left);
            make.right.equalTo(self.contentView);
            make.height.offset(0.5);
            make.top.equalTo(_meetTheAddressLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomLineView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(245);
            make.height.offset(200);
        }];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(260);
            make.height.offset(120);
            //make.bottom.equalTo(self.contentView).offset(-84);
        }];
        
        [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.top.equalTo(_pictureView.mas_bottom).offset(ghStatusCellMargin);
        }];
        
        [_separatedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_feedbackBtn.titleLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.right.equalTo(self.contentView);
            make.height.offset(ghStatusCellMargin);
        }];
        
        [_qualificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.mas_left);
            make.top.equalTo(_separatedLineView.mas_bottom).offset(12);
        }];
        
        [_qualificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualificationLabel.mas_bottom).offset(8);
            make.left.equalTo(_contentLabel.mas_left).offset(-0.1);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    
        // 从群组过来的需要分割线
        if (self.isGroupManager) {
            // 从群组过来的并且是群主显示删除按钮
//            [self.contentView addSubview:self.deleteBtn];
//            [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_feedbackBtn.mas_centerY);
//                make.right.equalTo(_feedbackBtn.mas_right);
//            }];
        }
    }
    
    
    if ([model.content_time isEqualToString:@""] && [model.content_addr isEqualToString:@""]) {
        _meetingTimeLabel.hidden = YES;
        _lineView.hidden = YES;
        _meetTheAddressLabel.hidden = YES;
        _bottomLineView.hidden = YES;
        
        
        
        NSString * conttent = model.content;
        CGRect rect = [conttent boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            if ([model.category_level_1 isEqualToString:@"BBS"]) {
//                make.top.equalTo(_separatedView.mas_bottom);
//            }else {
                make.top.equalTo(_separatedView.mas_bottom).offset(ghStatusCellMargin);
//            }
            make.left.equalTo(_subjectLabel.mas_left);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@(rect.size.height));
        }];
    }
    
    if (![model.content_time isEqualToString:@""] && [model.content_addr isEqualToString:@""]) {
        _meetTheAddressLabel.hidden = YES;
        _bottomLineView.hidden = YES;
        _meetingTimeLabel.text = [@"约定时间:" stringByAppendingString:[NSString stringWithFormat:@"%@",model.content_time]];
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineView.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(_subjectLabel.mas_left);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    
    if ([model.content_time isEqualToString:@""] && ![model.content_addr isEqualToString:@""]) {
        _meetingTimeLabel.hidden = YES;
        _lineView.hidden = YES;
        _meetTheAddressLabel.text = [@"约定地点:" stringByAppendingString:[NSString stringWithFormat:@"%@",model.content_addr]];
        [_meetTheAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_separatedView.mas_left);
            make.top.equalTo(_separatedView.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
    
    if (![model.content_time isEqualToString:@""] && ![model.content_addr isEqualToString:@""]) {
        
        _meetingTimeLabel.text = [@"约定时间:" stringByAppendingString:[NSString stringWithFormat:@"%@",model.content_time]];
        _meetTheAddressLabel.text = [@"约定地点:" stringByAppendingString:[NSString stringWithFormat:@"%@",model.content_addr]];
    }
    
    if ([model.content_requirement isEqualToString:@""]) {
        _qualificationLabel.hidden = YES;
        _separatedLineView.hidden = YES;
    }else {
        _qualificationContentLabel.text = model.content_requirement;
    }
    

    
    if (_qualificationLabel.hidden && _separatedLineView.hidden) {
        
        [_separatedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_feedbackBtn.titleLabel.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.offset(0);
        }];
        
        [_qualificationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.mas_left);
            make.top.equalTo(_separatedLineView.mas_bottom).offset(12);
            make.height.offset(0);
        }];
        
        [_qualificationContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_qualificationLabel.mas_bottom);
            make.left.equalTo(_contentLabel.mas_left).offset(-0.1);
            make.right.equalTo(self.contentView.mas_right).offset(-ghStatusCellMargin);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    
    
    if (model.pic.count == 1) {
        _picImageView.hidden = NO;
        _pictureView.hidden = YES;
        NSString *urlString = [imageUrlString stringByAppendingString:model.pic.lastObject];
        [_picImageView yy_setImageWithURL:[NSURL URLWithString:urlString] options:YYWebImageOptionShowNetworkActivity];
        [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(10);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(245);
            make.height.offset(200);
        }];
        [_pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.height.offset(0);
        }];
        
    }else{
        _picImageView.hidden = YES;
        _pictureView.hidden = NO;
        _pictureView.picArray = model.pic;
        [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.height.offset(0);
        }];
        [_pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(10);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.offset(255);
            make.height.offset(200);
            //make.bottom.equalTo(self.contentView).offset(-84);
        }];
        
    }

    if (model.pic.count < 1) {
        [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.height.offset(0);
            //make.bottom.equalTo(self.contentView);
        }];
        [_pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_picImageView.mas_bottom).offset(10);
            make.left.equalTo(_contentLabel.mas_left);
            make.width.height.offset(0);
            //make.bottom.equalTo(self.contentView).offset(-84);
        }];
        
        
        [_feedbackBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(_contentLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
    }
    
    self.picArray = model.pic;
    _subjectLabel.text = model.subject;
    if (model.content) {
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:model.content];
        text.yy_lineSpacing = 10;
        text.yy_font = [UIFont systemFontOfSize:16];
        _contentLabel.attributedText = text;
        CGSize size = [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth - 15 * 2, MAXFLOAT)];
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([model.category_level_1 isEqualToString:@"帮忙"]) {
                if (_meetingTimeLabel.hidden && _meetTheAddressLabel.hidden) {
                    make.top.equalTo(_bottomLineView.mas_bottom).offset(-25);
                }else{
                    make.top.equalTo(_bottomLineView.mas_bottom).offset(ghStatusCellMargin);
                }
            }else {
                make.top.equalTo(_separatedView.mas_bottom).offset(ghStatusCellMargin);
            }
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@(size.height));
            make.left.equalTo(self.contentView.mas_left).offset(14);
        }];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.money]
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
//    _moneyLabel.attributedText = str;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *im_namelogin = [userDefaults objectForKey:@"im_namelogin"];
    if ([model.user_id isEqualToString:im_namelogin]) {
        self.feedbackBtn.hidden = YES;
    }
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace baselineOffset:(CGFloat)baselineOffset {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    // 设置文本偏移量
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:range];
    return attributedString;
}

- (void)setIsGroup:(BOOL)isGroup {
    _isGroup = isGroup;
    // 从群组过来的分割线显示0.5
    if (_isGroup) {
        [_separatedLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.top.equalTo(_pictureView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        
        // 自动行高,让接单者完成要求的labeltop等于分割线的底部
        [_qualificationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_separatedLineView.mas_bottom).offset(ghSpacingOfshiwu);
        }];
        _feedbackBtn.hidden = YES;
//        // 投诉按钮在最底部
//        [_feedbackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_qualificationContentLabel.mas_bottom).offset(ghSpacingOfshiwu);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-ghSpacingOfshiwu);
//        }];
    }
}

- (void)fankuiBtnClike {
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *role_id = [userDefaults objectForKey:@"role_id"];
    
    BOOL sholdHide = [role_id isEqualToString:@"200"];
    
    if (sholdHide) {
        [WQAlert showAlertWithTitle:nil message:@"未登录不允许投诉" duration:1.5];
        return;
    }
    
    
    WQfeedbackViewController *feedbackVc = [WQfeedbackViewController new];
    [self.viewController.navigationController pushViewController:feedbackVc animated:YES];
}

- (void)setWhetherOrNotToReceive:(BOOL)whetherOrNotToReceive {
    if (whetherOrNotToReceive) {
        _redEnvelopeImageView.userInteractionEnabled = NO;
        _redEnvelopeLabel.text = @"已存入钱包";
        _redEnvelopeLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    //self.alreadyReceiveView.hidden = NO;
}

// 删除按钮的响应事件
- (void)deleteBtnClike {
    if ([self.delegate respondsToSelector:@selector(wqdeleteBtnClike:)]) {
        [self.delegate wqdeleteBtnClike:self];
    }
}

// 编辑图片
- (void)handleTapGes:(UITapGestureRecognizer *)tap{
    WQPhotoBrowser * browser = [[WQPhotoBrowser alloc] initWithDelegate:self];
    browser .currentPhotoIndex = 0;
    browser.alwaysShowControls = NO;
    
    browser.displayActionButton = NO;
    
    browser.shouldTapBack = YES;
    
    browser.shouldHideNavBar = YES;
    [self.viewController.navigationController pushViewController:browser animated:YES];
    
    
}

// 动画结束
- (void)endOfThe {
    NSLog(@"动画结束");
    [self.redEnvelopeImageView.layer removeAllAnimations];
    self.redEnvelopeLabel.text = @"点击领取";
    self.redEnvelopeImageView.userInteractionEnabled = YES;
    // [self.redEnvelopeImageView setAnimationImages:nil];
}

// 领红包
- (void)redEnvelopeImageViewClike {
    if (![WQDataSource sharedTool].isVerified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可领取"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                            
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    //self.redEnvelopeImageView.image = nil;
    //self.redEnvelopeImageView.hidden = YES;
    //self.redEnvelopeLabel.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(wqToReceiveBtnClike:)]) {
        [self.delegate wqToReceiveBtnClike:self];
    }
}

// 已经确认好了位置
// 在layoutSubviews中确认label的preferredMaxLayoutWidth值
- (void)layoutSubviews {
    [super layoutSubviews];
    // 必须在 [super layoutSubviews] 调用之后，contentLabel的frame有值之后设置preferredMaxLayoutWidth
    self.contentLabel.preferredMaxLayoutWidth = self.frame.size.width - 100;
    // 设置preferredLayoutWidth后，需要重新布局
    [super layoutSubviews];
}

#pragma mark - 懒加载
- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:17];
        _subjectLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        _subjectLabel.numberOfLines = 2;
    }
    return _subjectLabel;
}
- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _contentLabel;
}
- (UIView *)separatedView {
    if (!_separatedView) {
        _separatedView = [[UIView alloc] init];
        _separatedView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _separatedView;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.layer.masksToBounds = YES;
        _picImageView.layer.cornerRadius = 0;
        _picImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        [_picImageView addGestureRecognizer:tap];
    }
    return _picImageView;
}
//- (UILabel *)moneyLabel {
//    if (!_moneyLabel) {
//        _moneyLabel = [UILabel labelWithText:@"111" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:24];
//    }
//    return _moneyLabel;
//}
- (WQpictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[WQpictureView alloc] init];
    }
    return _pictureView;
}
- (UIButton *)feedbackBtn {
    if (!_feedbackBtn) {
        _feedbackBtn = [[UIButton alloc] init];
        _feedbackBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_feedbackBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [_feedbackBtn setTitleColor:[UIColor colorWithHex:0x878787] forState:UIControlStateNormal];
        [_feedbackBtn addTarget:self action:@selector(fankuiBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedbackBtn;
}
- (UIView *)separatedLineView {
    if (!_separatedLineView) {
        _separatedLineView = [[UIView alloc] init];
        _separatedLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _separatedLineView;
}
- (UILabel *)qualificationLabel {
    if (!_qualificationLabel) {
        _qualificationLabel = [UILabel labelWithText:@"对接单人的资质要求:" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:17];
        _qualificationLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    }
    return _qualificationLabel;
}
- (UILabel *)qualificationContentLabel {
    if (!_qualificationContentLabel) {
        _qualificationContentLabel = [[UILabel alloc] init];
        _qualificationContentLabel.textColor = [UIColor colorWithHex:0x333333];
        _qualificationContentLabel.font = [UIFont systemFontOfSize:16];
        _qualificationContentLabel.text = @"";
        _qualificationContentLabel.numberOfLines = 0;
    }
    return _qualificationContentLabel;
}

// 约定见面时间
- (UILabel *)meetingTimeLabel {
    if (!_meetingTimeLabel) {
        _meetingTimeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
        _meetingTimeLabel.numberOfLines = 0;
    }
    return _meetingTimeLabel;
}

// 约定见面时间下的线
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return _lineView;
}

- (UILabel *)meetTheAddressLabel {
    if (!_meetTheAddressLabel) {
        _meetTheAddressLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:14];
        _meetTheAddressLabel.numberOfLines = 0;
    }
    return _meetTheAddressLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return _bottomLineView;
}

- (UILabel *)watchLabel {
    if (!_watchLabel) {
        _watchLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:14];
    }
    return _watchLabel;
}

// 删除的按钮
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithHex:0x417dcc] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

// 红包下的label
- (UILabel *)redEnvelopeLabel {
    if (!_redEnvelopeLabel) {
        if ([self.model.can_bid boolValue]) {
            _redEnvelopeLabel = [UILabel labelWithText:@"红包装钱中..." andTextColor:UIColorWithHex16_(0x5d2a89) andFontSize:14];
        }else {
            _redEnvelopeLabel = [UILabel labelWithText:@"已存入钱包" andTextColor:UIColorWithHex16_(0x666666) andFontSize:14];
        }
        _redEnvelopeLabel.hidden = NO;
    }
    return _redEnvelopeLabel;
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
