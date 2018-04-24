//
//  WQsessionCollectionViewCell.h
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/16.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQsessionCollectionViewCell : UICollectionViewCell
-(void)setupUnreadMessageCount;
- (instancetype)initWithNid:(NSString *)nid
                needOwnerId:(NSString *)needOwnerId
                 isFromTemp:(BOOL)isFromTemp
                bidUserList:(NSSet *)bidUserList;
@end
