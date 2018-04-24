//
//  WQaccountDetailsTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQaccountDetailsTableViewCell.h"
#import "WQaccountDetailsModel.h"

@interface WQaccountDetailsTableViewCell()
//交易金额
@property (weak, nonatomic) IBOutlet UILabel *money;
//交易时间
@property (weak, nonatomic) IBOutlet UILabel *posttime;
//交易类型
@property (weak, nonatomic) IBOutlet UILabel *type;
//支付状态
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation WQaccountDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//     Initialization code
}

- (void)setModel:(WQaccountDetailsModel *)model
{
    _model = model;
    self.money.text = [NSString stringWithFormat:@"%.2f",model.money];
    self.posttime.text = model.posttime;
    self.type.text = model.type;
    self.message.text = model.message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
