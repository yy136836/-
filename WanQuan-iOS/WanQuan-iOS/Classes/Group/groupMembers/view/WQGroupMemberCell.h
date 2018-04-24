//
//  WQGroupMemberCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/24.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQGroupMemberModel.h"

@interface WQGroupMemberCell : UICollectionViewCell
@property (nonatomic, retain)WQGroupMemberModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end
