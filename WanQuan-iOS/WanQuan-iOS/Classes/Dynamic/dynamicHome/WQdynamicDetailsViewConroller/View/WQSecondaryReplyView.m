//
//  WQSecondaryReplyView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2018/1/12.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQSecondaryReplyView.h"
#import "WQDynamicLevelSecondaryModel.h"
#import "WQCommentDetailsViewController.h"

@interface WQSecondaryReplyView ()

@property (nonatomic, strong) MASConstraint *bottomCon;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UILabel *twoTagLabel;

@property (nonatomic, strong) UILabel *replyNumberLabel;

@end

@implementation WQSecondaryReplyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.userInteractionEnabled = YES;
    tagLabel.textColor = [UIColor colorWithHex:0x333333];
    tagLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tagLabel.font = [UIFont systemFontOfSize:14];
    self.tagLabel = tagLabel;
    tagLabel.numberOfLines = 0;
    UITapGestureRecognizer *tagLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagLabelTap)];
    [tagLabel addGestureRecognizer:tagLabelTap];
    [self addSubview:tagLabel];
    
    UILabel *twoTagLabel = [[UILabel alloc] init];
    twoTagLabel.userInteractionEnabled = YES;
    twoTagLabel.textColor = [UIColor colorWithHex:0x333333];
    twoTagLabel.lineBreakMode = NSLineBreakByCharWrapping;
    twoTagLabel.font = [UIFont systemFontOfSize:14];
    self.twoTagLabel = twoTagLabel;
    tagLabel.numberOfLines = 0;
    UITapGestureRecognizer *twoTagLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTagLabelTap)];
    [twoTagLabel addGestureRecognizer:twoTagLabelTap];
    [self addSubview:twoTagLabel];
    
    // 回复数量
    UILabel *replyNumberLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x844dc5] andFontSize:14];
    replyNumberLabel.userInteractionEnabled = YES;
    self.replyNumberLabel = replyNumberLabel;
    UITapGestureRecognizer *replyNumberLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replyNumberLabelTap)];
    [replyNumberLabel addGestureRecognizer:replyNumberLabelTap];
    [self addSubview:replyNumberLabel];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    if (self.comment_children_count == 1) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        NSString *name = [model.user_name stringByAppendingString:@": "];
        NSString *nameAddContent = [name stringByAppendingString:model.content];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
        self.tagLabel.attributedText = text;

        self.replyNumberLabel.text = @"";
        self.twoTagLabel.attributedText = [NSAttributedString new];
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.tagLabel.mas_bottom);
        }];
    }else if (self.comment_children_count == 2) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        if (model.reply_user_name.length) {
            NSString *nameAddContent = [[[model.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@: ",model.reply_user_name]] stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, model.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, model.reply_user_name.length)];
            self.tagLabel.attributedText = text;
        }else {
            NSString *name = [model.user_name stringByAppendingString:@": "];
            NSString *nameAddContent = [name stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
            self.tagLabel.attributedText = text;
        }

        WQDynamicLevelSecondaryModel *twomodel = dataArray[1];
        if (twomodel.reply_user_name.length) {
            NSString *twoNameAddContent = [[[twomodel.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@: ",twomodel.reply_user_name]] stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twomodel.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, twomodel.reply_user_name.length)];
            self.twoTagLabel.attributedText = twoText;
        }else {
            NSString *twoName = [twomodel.user_name stringByAppendingString:@": "];
            NSString *twoNameAddContent = [twoName stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twoName.length)];
            self.twoTagLabel.attributedText = twoText;
        }

        self.replyNumberLabel.text = @"";
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self.twoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tagLabel);
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.top.equalTo(self.tagLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.twoTagLabel.mas_bottom);
        }];
    }else if (self.comment_children_count > 2) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        if (model.reply_user_name.length) {
            NSString *nameAddContent = [[[model.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@: ",model.reply_user_name]] stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, model.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, model.reply_user_name.length)];
            self.tagLabel.attributedText = text;
        }else {
            NSString *name = [model.user_name stringByAppendingString:@": "];
            NSString *nameAddContent = [name stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
            self.tagLabel.attributedText = text;
        }

        WQDynamicLevelSecondaryModel *twomodel = dataArray[1];
        if (twomodel.reply_user_name.length) {
            NSString *twoNameAddContent = [[[twomodel.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@: ",twomodel.reply_user_name]] stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twomodel.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, twomodel.reply_user_name.length)];
            self.twoTagLabel.attributedText = twoText;
        }else {
            NSString *twoName = [twomodel.user_name stringByAppendingString:@": "];
            NSString *twoNameAddContent = [twoName stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twoName.length)];
            self.twoTagLabel.attributedText = twoText;
        }
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self.twoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tagLabel);
            make.top.equalTo(self.tagLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        self.replyNumberLabel.text = [NSString stringWithFormat:@"共%zd条回复>",self.comment_children_count];
        [self.replyNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.top.equalTo(self.twoTagLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(self.twoTagLabel);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.replyNumberLabel.mas_bottom);
        }];
    }
    
    
    /*
    if (self.comment_children_count == 1) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        NSString *name = [model.user_name stringByAppendingString:@":\t"];
        NSString *nameAddContent = [name stringByAppendingString:model.content];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
        self.tagLabel.attributedText = text;

        self.replyNumberLabel.text = @"";
        self.twoTagLabel.attributedText = [NSAttributedString new];
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.tagLabel.mas_bottom);
        }];
    }else if (self.comment_children_count == 2) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        if (model.reply_user_name.length) {
            NSString *nameAddContent = [[[model.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@:\t",model.reply_user_name]] stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, model.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, model.reply_user_name.length)];
            self.tagLabel.attributedText = text;
        }else {
            NSString *name = [model.user_name stringByAppendingString:@":\t"];
            NSString *nameAddContent = [name stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
            self.tagLabel.attributedText = text;
        }

        WQDynamicLevelSecondaryModel *twomodel = dataArray[1];
        if (twomodel.reply_user_name.length) {
            NSString *twoNameAddContent = [[[twomodel.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@:\t",twomodel.reply_user_name]] stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twomodel.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, twomodel.reply_user_name.length)];
            self.twoTagLabel.attributedText = twoText;
        }else {
            NSString *twoName = [twomodel.user_name stringByAppendingString:@":\t"];
            NSString *twoNameAddContent = [twoName stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twoName.length)];
            self.twoTagLabel.attributedText = twoText;
        }

        self.replyNumberLabel.text = @"";
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self.twoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tagLabel);
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.top.equalTo(self.tagLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.twoTagLabel.mas_bottom);
        }];
    }else if (self.comment_children_count > 2) {
        WQDynamicLevelSecondaryModel *model = dataArray[0];
        if (model.reply_user_name.length) {
            NSString *nameAddContent = [[[model.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@:\t",model.reply_user_name]] stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, model.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, model.reply_user_name.length)];
            self.tagLabel.attributedText = text;
        }else {
            NSString *name = [model.user_name stringByAppendingString:@":\t"];
            NSString *nameAddContent = [name stringByAppendingString:model.content];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:nameAddContent];
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, name.length)];
            self.tagLabel.attributedText = text;
        }

        WQDynamicLevelSecondaryModel *twomodel = dataArray[1];
        if (twomodel.reply_user_name.length) {
            NSString *twoNameAddContent = [[[twomodel.user_name stringByAppendingString:@"回复"] stringByAppendingString:[NSString stringWithFormat:@"%@:\t",twomodel.reply_user_name]] stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twomodel.user_name.length)];
            NSString *str = [model.user_name stringByAppendingString:@"回复"];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(str.length, twomodel.reply_user_name.length)];
            self.twoTagLabel.attributedText = twoText;
        }else {
            NSString *twoName = [twomodel.user_name stringByAppendingString:@":\t"];
            NSString *twoNameAddContent = [twoName stringByAppendingString:twomodel.content];
            NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc] initWithString:twoNameAddContent];
            [twoText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x844dc5] range:NSMakeRange(0, twoName.length)];
            self.twoTagLabel.attributedText = twoText;
        }
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(ghStatusCellMargin);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        [self.twoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.tagLabel);
            make.top.equalTo(self.tagLabel.mas_bottom).offset(ghStatusCellMargin);
        }];
        self.replyNumberLabel.text = [NSString stringWithFormat:@"共%zd条回复>",self.comment_children_count];
        [self.replyNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-ghStatusCellMargin);
            make.top.equalTo(self.twoTagLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(self.twoTagLabel);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.replyNumberLabel.mas_bottom);
        }];
    }
     */
}

- (void)tagLabelTap {
    if ([self.delegate respondsToSelector:@selector(wqTagLabelTap:)]) {
        [self.delegate wqTagLabelTap:self];
    }
}

- (void)twoTagLabelTap {
    if ([self.delegate respondsToSelector:@selector(wqTwoTagLabelTap:)]) {
        [self.delegate wqTwoTagLabelTap:self];
    }
}

- (void)replyNumberLabelTap {
    if ([self.delegate respondsToSelector:@selector(wqReplyNumberLabelTap:)]) {
        [self.delegate wqReplyNumberLabelTap:self];
    }
}

@end
