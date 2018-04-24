//
//  WQworkExperienceTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/3.
//  Copyright © 2017年 WQ. All rights reserved.
//Education

#import "WQworkExperienceTableViewCell.h"
#import "WQTwoUserProfileModel.h"

@interface WQworkExperienceTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *corporationLabel;  //公司名称
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;     //职位名称
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;         //时间
@property (weak, nonatomic) IBOutlet UILabel *jiesushijian;      //结束时间

@end

@implementation WQworkExperienceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)changeBtnClike:(id)sender {
    if (self.modifyBtnClikeBlock) {
        self.modifyBtnClikeBlock();
    }
}
- (IBAction)add:(id)sender {
}

- (void)setModel:(WQTwoUserProfileModel *)model
{
    _model = model;
    self.corporationLabel.text = model.work_enterprise ? : model.education_school;
    self.positionLabel.text = model.work_enterprise ? : model.work_position;
    self.dataLabel.text = model.education_start_time ? : model.work_start_time;
    self.jiesushijian.text = model.work_end_time ? : model.education_end_time;
}

@end
