//
//  WQShareFriendListController.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/28.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQGroupModel.h"
//#import "WQShareGroupInfoModel.h"
////@interface WQShareGroupInfoModel : NSObject;
////
////@property (nonatomic,copy) NSString * name;
////@property (nonatomic,copy) NSString * des;
////@property (nonatomic,copy) NSString * mumberNum;
////@property (nonatomic,copy) NSString * pic;
////
////
////@end
////
////@implementation WQShareGroupInfoModel
////
////
////
////@end


@interface WQShareFriendListController : UIViewController

@property (nonatomic, copy) NSString * gid;

@property (nonatomic, retain) WQGroupModel * groupModel;
@end
