//
//  WQUserExperienceWithOutPossitionCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/8/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserExperienceWithOutPossitionCell.h"
#import "WQUserConfimModel.h"
#import "UIButton+EMWebCache.h"

@interface WQUserExperienceWithOutPossitionCell ()


@property (weak, nonatomic) IBOutlet UIImageView *slice;

/**
 公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *corporationLabel;


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

@implementation WQUserExperienceWithOutPossitionCell

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
    NSArray * arr = workModel.confirms.copy;
    workModel.confirms = [NSArray yy_modelArrayWithClass:[WQUserConfimModel class] json:workModel.confirms];
    _workModel = workModel;
    self.corporationLabel.text = workModel.work_enterprise;

    NSString * start = [[workModel.work_start_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    NSString * end = [[workModel.work_end_time componentsSeparatedByString:@"-"] componentsJoinedByString:@"."];
    self.dataLabel.text =[NSString stringWithFormat:@"%@ - %@", start ,end];
    
    if (workModel.confirms.count >= 1) {
        WQUserConfimModel *model = workModel.confirms[0];
        NSString * picURLString = model.pic_truename;
        picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
        [_authenticationImageLeft sd_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)]  forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor cyanColor]]];
        
        _renzhengBtn.enabled = YES;
        _confirmLabel.text =  @"帮他认证:";

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
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_logo yy_setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:@"zhanweilogo"]];
    workModel.confirms = arr;
}



- (void)confim:(UIButton *)sender {
    
    if (self.workModel) {
        if (self.workModel.confirms.count == 2) {
            return;
        }
    }


    if (!sender.enabled) {
        return;
    }
    if (self.goConfim) {
        self.goConfim();
    }
}

@end
