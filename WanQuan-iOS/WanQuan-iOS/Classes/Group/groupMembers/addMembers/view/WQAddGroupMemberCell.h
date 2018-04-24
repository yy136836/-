//
//  WQAddGroupMemberCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/23.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQfriend_listModel.h"
#import "WQGroupMemberModel.h"

@class WQGroupMemberModel;

@interface WQAddGroupMemberCell : UITableViewCell

@property (nonatomic, retain) WQfriend_listModel * model;
@property (nonatomic, retain) WQGroupMemberModel * groupMemberModel;

@end
