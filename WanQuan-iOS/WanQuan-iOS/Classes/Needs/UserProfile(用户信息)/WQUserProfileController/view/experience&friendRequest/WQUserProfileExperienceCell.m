//
//  WQUserProfileExperienceCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileExperienceCell.h"
#import "WQUserConfimModel.h"
#import "UIButton+EMWebCache.h"

@interface WQUserProfileExperienceCell ()


@property (weak, nonatomic) IBOutlet UIImageView *slice;
/**
 公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *corporationLabel;

/**
 职务名称
 */
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;


/**
 工作起止时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;        //时间

/**
 已认证或者帮他认证 label
 */
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;



/**
 认证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *renzhengBtn;     //帮他认证Btn

/**
 认证人1的头像
 */
@property (weak, nonatomic) IBOutlet UIButton *authenticationImageLeft;

/**
 认证人2的头像
 */
@property (weak, nonatomic) IBOutlet UIButton *authenticationImageRight;


@property (nonatomic, retain) UIImage * oriImage;

@property (weak, nonatomic) IBOutlet UIImageView *logo;


@end


@implementation WQUserProfileExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =[UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    UIImage * image = [UIImage imageNamed:@"Slice2"];
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:image.size.height - 5];
    _slice.image = image;
    _authenticationImageLeft.layer.cornerRadius = 12;
    _authenticationImageLeft.layer.masksToBounds = YES;
    _authenticationImageRight.layer.cornerRadius = 12;
    _authenticationImageRight.layer.masksToBounds = YES;
    
    _oriImage = [UIImage imageNamed:@"tianjiajingli"];
    
    [_renzhengBtn addTarget:self action:@selector(confim:) forControlEvents:UIControlEventTouchUpInside];
    if (kScreenWidth == 320) {
        _dataLabel.font = [UIFont systemFontOfSize:10];
        _confirmLabel.font = [UIFont systemFontOfSize:10];
    } else {
        _dataLabel.font = [UIFont systemFontOfSize:12];
        _confirmLabel.font = [UIFont systemFontOfSize:12];
    }
    _authenticationImageLeft.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _authenticationImageRight.imageView.contentMode = UIViewContentModeScaleAspectFill;

}

- (void)setWorkModel:(WQUserWorkExperienceModel *)workModel {
    
    NSArray * arr  = workModel.confirms.copy;
    workModel.confirms = [NSArray yy_modelArrayWithClass:[WQUserConfimModel class] json:workModel.confirms];
    _workModel = workModel;
    _confirmLabel.text =  @"帮他认证:";

//    _rightArrow.hidden = self.self
    self.corporationLabel.text = workModel.work_enterprise;
    self.positionLabel.text = workModel.work_position;
    NSString * start = [[workModel.work_start_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    NSString * end = [[workModel.work_end_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    self.dataLabel.text =[NSString stringWithFormat:@"%@ - %@", start ,end];
    
    if (workModel.confirms.count >= 1) {
        WQUserConfimModel *model = workModel.confirms[0];
        NSString * picURLString = model.pic_truename;
        picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
        [_authenticationImageLeft sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)]  forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor cyanColor]]];
        
        _renzhengBtn.enabled = YES;
        
        if (workModel.confirms.count >= 2) {
            
            model = workModel.confirms[1];
            NSString * picURLString = model.pic_truename;
            picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
            [_authenticationImageRight sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)]  forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor cyanColor]]];
            _confirmLabel.text = @"已认证:";
            _renzhengBtn.enabled = NO;
            
        }
        
    }
    
    if (workModel.confirms.count == 0) {
        _confirmLabel.text = @"";
        [_authenticationImageLeft setImage:_oriImage forState:UIControlStateNormal];
        [_authenticationImageRight setImage:_oriImage forState:UIControlStateNormal];
        _confirmLabel.text =  @"帮他认证:";
        _renzhengBtn.enabled = YES;
        
    }
    
    NSString * str = LOGO_WORK_PLACE(workModel.work_enterprise);
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_logo yy_setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:@"zhanweilogo"] options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    workModel.confirms = arr;
}

- (void)setEducationModel:(WQUserEducationExperienceModel *)educationModel {
    NSArray * arr  = educationModel.confirms.copy;

    _confirmLabel.text =  @"帮他认证:";
    educationModel.confirms = [NSArray yy_modelArrayWithClass:[WQUserConfimModel class] json:educationModel.confirms];

    _educationModel = educationModel;

    self.corporationLabel.text = educationModel.education_school;
    
    //    //学位（1：小学 2：中学 3：本科，4：硕士，5：博士）
    //    @property (nonatomic, assign) int education_degree;
    
    NSString * degree = @"";
    switch (educationModel.education_degree.integerValue) {
        case 1:{
            degree = @"中学及以下";
            break;
        }
        case 2:{
            degree = @"大专";
            break;
        }
        case 3:{
            degree = @"本科";
            break;
        }
        case 4:{
            degree = @"硕士";
            break;
        }
        case 5:{
            degree = @"博士";
            break;
        }
            
        default:
            break;
    }
    
    self.positionLabel.text = [NSString stringWithFormat:@"%@ %@",educationModel.education_major, degree];
    NSString * start = [[educationModel.education_start_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    NSString * end = [[educationModel.education_end_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    self.dataLabel.text =[NSString stringWithFormat:@"%@ - %@", start ,end];
    
    if (educationModel.confirms.count >= 1) {
        WQUserConfimModel *model = educationModel.confirms[0];
        NSString * picURLString = model.pic_truename;
        picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
        [_authenticationImageLeft yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
//        [_authenticationImageLeft sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)]  forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor cyanColor]]];
        
        
        
        [_authenticationImageRight setImage:_oriImage forState:UIControlStateNormal];
        _renzhengBtn.enabled = YES;
        
        if (educationModel.confirms.count >= 2) {
            
            model = educationModel.confirms[1];
            //        [_authenticationImageRight sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)]  forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor cyanColor]]];
            
            [_authenticationImageRight yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
            _confirmLabel.text = @"已认证:";
            _renzhengBtn.enabled = NO;
        }
    }
    
    if (educationModel.confirms.count == 0) {
        _confirmLabel.text = @"";
        [_authenticationImageLeft setImage:_oriImage forState:UIControlStateNormal];
        [_authenticationImageRight setImage:_oriImage forState:UIControlStateNormal];
        _confirmLabel.text =  @"帮他认证";
        _renzhengBtn.enabled = YES;
        
    }
    
    NSString * str = LOGO_SCHOLL(educationModel.education_school);
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSURL * url = [NSURL URLWithString:str];
    
    
    
    [_logo yy_setImageWithURL:URL(str)
                  placeholder:[UIImage imageNamed:@"zhanweilogo"]
                      options:YYWebImageOptionProgressive
                   completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    educationModel.confirms = arr;
}

- (void)confim:(UIButton *)sender {
    if (!sender.enabled) {
        return;
    }
    
    if (self.workModel) {
        if (self.workModel.confirms.count == 2) {
            return;
        }
    }
    
    if (self.educationModel) {
        if (self.educationModel.confirms.count == 2) {
            return;
        }
    }
    
    if (self.goConfim) {
        self.goConfim();
    }
}
@end
