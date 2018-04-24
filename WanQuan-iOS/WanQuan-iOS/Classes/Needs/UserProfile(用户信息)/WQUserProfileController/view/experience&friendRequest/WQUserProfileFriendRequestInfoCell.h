//
//  WQUserProfileFriendRequestInfoCell.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQUserProfileFriendRequestInfoCell : UITableViewCell
@property (nonatomic, copy) NSString * requestInfo;
@property (nonatomic, copy) NSString * userName;
- (CGFloat)heightWithText:(NSString *)requestInfo;
@end
