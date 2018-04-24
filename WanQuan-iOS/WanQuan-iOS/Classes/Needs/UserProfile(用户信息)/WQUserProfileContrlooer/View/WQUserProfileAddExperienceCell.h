//
//  WQUserProfileAddExperienceCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/4/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addAction)(UIButton * addButton);

@interface WQUserProfileAddExperienceCell : UITableViewCell
@property(nonatomic, retain) UIButton * addButton;
@end
