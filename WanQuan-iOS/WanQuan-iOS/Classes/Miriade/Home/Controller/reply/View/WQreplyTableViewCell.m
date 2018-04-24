//
//  WQreplyTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQreplyTableViewCell.h"
#import "WQreplyModel.h"

@interface WQreplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *user_pic; //用户头像
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *user_name;    //用户名
@property (weak, nonatomic) IBOutlet UILabel *past_second;  //以过时间
@end

@implementation WQreplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.user_pic.layer.cornerRadius = 5;
    self.user_pic.layer.masksToBounds = YES;
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(WQreplyModel *)model {
    _model = model;
    NSString *imageUrl = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",model.user_pic]];
    [self.user_pic yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:0];
    self.user_name.text = model.user_name;
    self.content.text = model.content;
    
    NSInteger time = model.past_second;
    if (time < 60) {
        self.past_second.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        self.past_second.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        self.past_second.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        self.past_second.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
    
}

@end
