//
//  WQaskButtonTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQaskButtonTableViewCell.h"

@interface WQaskButtonTableViewCell()

@end

@implementation WQaskButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHex:0xededed];
        [self hideOrShowDot:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldShowRedNotifacation object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot:) name:WQShouldHideRedNotifacation object:nil];
    }
    return self;
}







- (void)hideOrShowDot:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL haveRed = [WQUnreadMessageCenter haveUnreadTmpChatForBid:self.id];
        self.redView.hidden = !haveRed;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
}



#pragma mark - 初始化UI
- (void)setupUI
{
    UIButton *askBtn = [[UIButton alloc] init];
    askBtn.backgroundColor = [UIColor whiteColor];
    [askBtn setImage:[UIImage imageNamed:@"linshihuihua"] forState:UIControlStateNormal];
    [askBtn setTitle:@"回答未接单者的询问" forState:UIControlStateNormal];
    [askBtn setTitleColor:WQ_LIGHT_PURPLE forState:UIControlStateNormal];
    askBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    askBtn.layer.masksToBounds = YES;
    askBtn.layer.cornerRadius = 5;
    __weak typeof(self) weakSelf = self;
    [askBtn addClickAction:^(UIButton * _Nullable sender) {
        if (weakSelf.askBtnCliekBlock) {
            weakSelf.askBtnCliekBlock();
        }
    }];
    [self addSubview:askBtn];
    [askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.left.equalTo(self).offset(ghStatusCellMargin);
        make.right.equalTo(self).offset(-ghStatusCellMargin);
        make.top.equalTo(self).offset(15);
    }];
    
    [askBtn.imageView addSubview:self.redView];
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(askBtn.imageView.mas_top);
        make.right.equalTo(askBtn.imageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
}

-(UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        _redView.hidden = NO;
    }
    return _redView;
}

@end
