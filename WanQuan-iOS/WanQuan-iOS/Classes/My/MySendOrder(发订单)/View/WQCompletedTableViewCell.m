//
//  WQCompletedTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/12.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQCompletedTableViewCell.h"
#import "WQWaitOrderModel.h"

@interface WQCompletedTableViewCell()
@property (strong, nonatomic) UILabel *subject;  //内容
@property (strong, nonatomic) UILabel *forwardingNumber;// 转发
@property (nonatomic, copy) NSString *huanxinID;        //环信ID
@property (strong, nonatomic) UILabel *checkTheNumber;// 查看
@end

@implementation WQCompletedTableViewCell

- (void)setWaitorderModel:(WQWaitOrderModel *)waitorderModel {
    _waitorderModel = waitorderModel;
    self.subject.text = waitorderModel.subject;
    self.huanxinID = waitorderModel.id;
    self.forwardingNumber.text = waitorderModel.share_count;
    self.checkTheNumber.text = waitorderModel.view_count;
}
- (IBAction)applicationForDrawbackBtnClike:(id)sender {
    if (self.applicationForDrawbackBtnClikeBlock) {
        self.applicationForDrawbackBtnClikeBlock();
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
        self.contentView.backgroundColor = [UIColor colorWithHex:0xf3f3f3];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    // 背景框,因为有阴影
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdancellbottom"]];
    backgroundImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.contentView).offset(ghStatusCellMargin); 
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
        make.bottom.equalTo(self.contentView);
    }];
    
    // 标题
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    [self.contentView addSubview:self.subject];
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.left.equalTo(backgroundImageView).offset(7);
        make.right.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
    }];
    
    // 分享图片
    UIImageView *sharImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanzhuanfa"]];
    [self.contentView addSubview:sharImageView];
    [sharImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundImageView).offset(ghSpacingOfshiwu);
        make.top.equalTo(self.subject.mas_bottom).offset(ghStatusCellMargin);
    }];
    
    // 分享数量
    self.forwardingNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.forwardingNumber];
    [self.forwardingNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sharImageView.mas_centerY);
        make.left.equalTo(sharImageView.mas_right).offset(5);
    }];
    
    // 观看图片
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdanliulan"]];
    [self.contentView addSubview:checkImageView];
    [checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(sharImageView.mas_centerY);
        make.bottom.equalTo(sharImageView.mas_bottom);
        make.left.equalTo(self.forwardingNumber.mas_right).offset(ghDistanceershi);
    }];
    
    // 观看数量
    self.checkTheNumber = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x999999] andFontSize:12];
    [self.contentView addSubview:self.checkTheNumber];
    [self.checkTheNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkImageView.mas_centerY);
        make.left.equalTo(checkImageView.mas_right).offset(5);
    }];
}

@end
