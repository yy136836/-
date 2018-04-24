//
//  WQUserProfileNeedCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileNeedCell.h"

@interface WQUserProfileNeedCell()
@property (weak, nonatomic) IBOutlet UILabel *needTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *needCottentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;
@property (nonatomic, retain) UIImage * slideImage;

@end


@implementation WQUserProfileNeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];

}

- (void)setModel:(WQUserProfileNeedModel *)model {
    _model = model;
    _needTitlelabel.text = model.subject;
    _needCottentLabel.text = model.content;
    UIImage * oriImage = [UIImage imageNamed:@"Slice2"];
    _slideImage = [oriImage stretchableImageWithLeftCapWidth:0
                                                topCapHeight:_slideImage.size.height * 0.9];
    _slideImageView.image = _slideImage;
    
}

@end
