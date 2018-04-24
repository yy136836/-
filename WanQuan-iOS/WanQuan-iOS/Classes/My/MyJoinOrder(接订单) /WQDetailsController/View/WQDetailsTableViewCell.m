//
//  WQDetailsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/31.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQDetailsTableViewCell.h"
#import "WQHomeNearby.h"

@interface WQDetailsTableViewCell()  
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *user_pic;
//用户名称
@property (weak, nonatomic) IBOutlet UILabel *user_name;
//标题
@property (weak, nonatomic) IBOutlet UILabel *subject;
//内容
@property (weak, nonatomic) IBOutlet UILabel *content;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *Money;
@property (weak, nonatomic) IBOutlet UIImageView *pictwo;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation WQDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}
- (IBAction)ConfirmClike:(id)sender {
    if (self.confirmBtnClikeBlock) {
        self.confirmBtnClikeBlock();
    }
}

- (void)setupUI
{
    _user_pic.layer.cornerRadius = 22;
    _user_pic.layer.masksToBounds = YES;
    _user_pic.contentMode = UIViewContentModeScaleAspectFill;
    
    NSArray *picArr = @[self.pic,self.pictwo];
    
    [picArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:18 leadSpacing:18 tailSpacing:64];
    [picArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-18);
    }];
}

- (void)setModel:(WQHomeNearby *)model
{
    _model = model;
    self.timeLabel.text = model.finished_date;
    NSString *user_picUrlString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",model.user_pic]];
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:user_picUrlString] options:0];
    self.user_name.text = model.user_name;
    self.subject.text = model.subject;
    self.content.text = model.content;
    self.pic.image = model.imageArray.firstObject;
    if (model.imageArray.count >= 1) {
        self.pictwo.image = model.imageArray.lastObject;
    }
    self.Money.text = [NSString stringWithFormat:@"%d",model.money];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
