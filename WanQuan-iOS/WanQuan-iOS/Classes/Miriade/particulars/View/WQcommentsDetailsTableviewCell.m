//
//  WQcommentsDetailsTableviewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/27.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQcommentsDetailsTableviewCell.h"
#import "WQcommentListModel.h"

@interface WQcommentsDetailsTableviewCell()
@property (strong, nonatomic) UIImageView *user_pic;  //用户头像
@property (strong, nonatomic) UILabel *user_name;     //用户名
@property (strong, nonatomic) UILabel *past_second;   //距离评论时间
@property (strong, nonatomic) UILabel *content;       //内容
@property (strong, nonatomic) UIView *lineView;       //底部分隔线
@end

@implementation WQcommentsDetailsTableviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化控件
- (void)setupUI {
    [self.contentView addSubview:self.user_pic];
    [self.contentView addSubview:self.user_name];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.past_second];
    [self.contentView addSubview:self.lineView];
    
    [_user_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.contentView).offset(ghStatusCellMargin);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [_user_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_user_pic.mas_top).offset(6);
        make.left.equalTo(_user_pic.mas_right).offset(ghStatusCellMargin);
    }];
    [_past_second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_user_name.mas_left);
        make.top.equalTo(_user_name.mas_bottom).offset(7);
    }];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_user_name.mas_left);
        make.top.equalTo(_past_second.mas_bottom).offset(16);
        make.right.equalTo(self.contentView).offset(-25);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_user_name.mas_left);
        make.top.equalTo(_content.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(ghStatusCellMargin);
        make.right.equalTo(self.contentView);
        make.height.offset(0.5);
    }];
}

- (void)setModel:(WQcommentListModel *)model {
    _model = model;
    self.user_name.text = model.user_name;

    NSInteger time = [model.past_second integerValue];
    if (time < 60) {
        self.past_second.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        self.past_second.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.past_second.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        self.past_second.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
    
    self.content.text = model.content;
    //NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",model.user_pic]];
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.user_pic)] options:0];
}

// 点击群头像
- (void)handleTapGes:(UITapGestureRecognizer *)tap {
//    if ([self.delegate respondsToSelector:@selector(wqUser_picClick:)]) {
//        [self.delegate wqUser_picClick:self];
//    }
}

#pragma mark - 懒加载
- (UIImageView *)user_pic {
    if (!_user_pic) {
        _user_pic = [[UIImageView alloc] init];
        _user_pic.layer.cornerRadius = 5;
        _user_pic.layer.masksToBounds = YES;
        _user_pic.contentMode = UIViewContentModeScaleAspectFill;
        _user_pic.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGes:)];
        _user_pic.backgroundColor = [UIColor whiteColor];
        [_user_pic addGestureRecognizer:tap];
    }
    return _user_pic;
}
- (UILabel *)user_name {
    if (!_user_name) {
        _user_name = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:13];
    }
    return _user_name;
}
-(UILabel *)past_second {
    if (!_past_second) {
        _past_second = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:10];
    }
    return _past_second;
}
- (UILabel *)content {
    if (!_content) {
        _content = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:14];
        _content.numberOfLines = 0;
    }
    return _content;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    }
    return _lineView;
}



@end
