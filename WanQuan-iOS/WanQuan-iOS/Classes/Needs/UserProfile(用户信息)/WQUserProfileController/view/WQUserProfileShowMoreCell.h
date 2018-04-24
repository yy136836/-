//
//  WQUserProfileShowMoreCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^UserProfileShowMore)(void);

@interface WQUserProfileShowMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;

@property (nonatomic, copy) UserProfileShowMore showMoreInfo;

@end
