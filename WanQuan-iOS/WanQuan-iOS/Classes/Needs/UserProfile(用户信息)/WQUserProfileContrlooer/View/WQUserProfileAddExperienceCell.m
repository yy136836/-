//
//  WQUserProfileAddExperienceCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileAddExperienceCell.h"

@interface WQUserProfileAddExperienceButton : UIButton

@end

@implementation WQUserProfileAddExperienceButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.centerX - 60, 20 - 8, 16, 16);
}
    
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(self.centerX - 20, 20 - 13, 200, 25);
}

@end

@implementation WQUserProfileAddExperienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _addButton = [[WQUserProfileAddExperienceButton alloc] init];
        
        [self.contentView addSubview:_addButton];
        
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@40);
            make.left.equalTo(@0);
            make.top.equalTo(@0);
        }];
        
        
        [_addButton setImage: [UIImage imageNamed:@"tianjia"]  forState:UIControlStateNormal];

        [_addButton setTitle:@"    " forState:UIControlStateNormal];
        _addButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addButton setTitleColor:[UIColor colorWithHex:0x5d2a89]
                         forState:UIControlStateNormal];
        _addButton.userInteractionEnabled = NO;
        
        
//        UIView * grayLine = [[UIView alloc] init];
//        grayLine.backgroundColor = [UIColor colorWithHex:0xededed];
//        [self.contentView addSubview:grayLine];
//        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left);
//            make.right.equalTo(self.contentView.mas_right);
//            make.height.equalTo(@(0.5));
//            make.top.equalTo(self.contentView.mas_top);
//        }];
    }
    return self;
}



@end
