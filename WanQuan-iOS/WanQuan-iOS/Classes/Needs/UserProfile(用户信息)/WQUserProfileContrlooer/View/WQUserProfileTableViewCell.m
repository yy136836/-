//
//  WQUserProfileTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/12/2.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQUserProfileTableViewCell.h"
#import "WQTwoUserProfileModel.h"
#import "WQUserProfileModel.h"
#import "WQconfirmsModel.h"
#import "WQTwoWorkUserProfileModel.h"
#import "WQTwoWorkconfirmsModel.h"

@interface WQUserProfileTableViewCell ()



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
@property (weak, nonatomic) IBOutlet UIImageView *authenticationImageLeft;

/**
 认证人2的头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *authenticationImageRight;





@end

@implementation WQUserProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _topLineView.frame = CGRectMake(_topLineView.x, _topLineView.y, _topLineView.width, 0.5);
    _authenticationImageLeft.layer.cornerRadius = 4;
    _authenticationImageLeft.layer.masksToBounds = YES;
    _authenticationImageRight.layer.cornerRadius = 4;
    _authenticationImageRight.layer.masksToBounds = YES;
}

- (IBAction)certificationBtnClike:(id)sender {
    if (self.certificationBtnClikeBlock) {
        self.certificationBtnClikeBlock();
    }
}

//教育经历
- (void)setUserProfileModel:(WQTwoUserProfileModel *)userProfileModel
{
    _confirmLabel.text =  @"帮他认证";

    
//    @property (nonatomic, strong) NSArray<WQconfirmsModel *> *confirms;
//    //公司名称
//    @property (nonatomic, copy) NSString *work_enterprise;
//    //工作开始时间
//    @property (nonatomic, copy) NSString *work_start_time;
//    //工作结束时间
//    @property (nonatomic, copy) NSString *work_end_time;
//    //工作职位
//    @property (nonatomic, copy) NSString *work_position;
//    //工作具体描述
//    @property (nonatomic, copy) NSString  *work_detail;
//    //工作ID
//    @property (nonatomic, copy) NSString *type;
//    //学校名称
//    @property (nonatomic, copy) NSString *education_school;
//    //教育经历开始时间
//    @property (nonatomic, copy) NSString *education_start_time;
//    //教育经历结束时间
//    @property (nonatomic, copy) NSString *education_end_time;
//    //专业
//    @property (nonatomic, copy) NSString *education_major;
//    //学位（1：小学 2：中学 3：本科，4：硕士，5：博士）
//    @property (nonatomic, assign) int education_degree;
    
    _userProfileModel = userProfileModel;
    self.corporationLabel.text = userProfileModel.education_school;
    self.positionLabel.text = userProfileModel.education_major;
    self.dataLabel.text = userProfileModel.education_start_time;
    
    
    if (userProfileModel.confirms.count >= 1) {
        WQconfirmsModel *model = userProfileModel.confirms[0];
        //NSString * picURLString = model.pic_truename;
        //picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
        [_authenticationImageLeft yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
        _renzhengBtn.enabled = YES;
        if (userProfileModel.confirms.count >= 2) {

            model = userProfileModel.confirms[1];
            //picURLString = model.pic_truename;
            //picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
            
            [_authenticationImageRight yy_setImageWithURL:[NSURL URLWithString:WEB_IMAGE_TINY_URLSTRING(model.pic_truename)] options:0];
            _confirmLabel.text = @"已认证";
            _renzhengBtn.enabled = NO;
        }
    }
    if (userProfileModel.confirms.count == 0) {
        _confirmLabel.text = @"";
        _authenticationImageLeft.image = nil;
        _authenticationImageRight.image = nil;
        _confirmLabel.text =  @"帮他认证";
        _renzhengBtn.enabled = YES;

    }
}

//工作经历
-  (void)setProfileMode:(WQTwoWorkUserProfileModel *)profileMode {
    _confirmLabel.text =  @"帮他认证";
    _profileMode = profileMode;
    self.corporationLabel.text = _profileMode.work_enterprise;
    self.positionLabel.text = _profileMode.work_position;
    self.dataLabel.text = _profileMode.work_start_time;
    
    if (_profileMode.confirms.count >= 1) {
        WQTwoWorkconfirmsModel *model = _profileMode.confirms[0];
        NSString * picURLString = model.pic_truename;
        picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
        [_authenticationImageLeft sd_setImageWithURL:[NSURL URLWithString:picURLString] placeholderImage:[UIImage imageNamed:@""]];

        _renzhengBtn.enabled = YES;

        if (_profileMode.confirms.count >= 2) {
            
            
            model = _profileMode.confirms[1];
            NSString * picURLString = model.pic_truename;
            picURLString = [imageUrlString stringByAppendingString:[NSString stringWithFormat:@"%@",picURLString]];
            [_authenticationImageRight yy_setImageWithURL:[NSURL URLWithString:picURLString] options:0];
             _confirmLabel.text = @"已认证";
            _renzhengBtn.enabled = NO;

        }
        
    }
    
    if (profileMode.confirms.count == 0) {
        _confirmLabel.text = @"";
        _authenticationImageLeft.image = nil;
        _authenticationImageRight.image = nil;
        _confirmLabel.text =  @"帮他认证";
        _renzhengBtn.enabled = YES;

    }
    

}

//- (void)setWorkconfirmsModel:(WQTwoWorkconfirmsModel *)workconfirmsModel
//{
//    _workconfirmsModel = workconfirmsModel;
//    self.renzhengName.text = workconfirmsModel.true_name;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0Xefeff4];
    }
    return self;
}

@end
