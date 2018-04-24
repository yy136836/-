//
//  WQUserProfileFriendRequestInfoCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/10/18.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileFriendRequestInfoCell.h"

@interface WQUserProfileFriendRequestInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *requestInfolabel;

@end
@implementation WQUserProfileFriendRequestInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRequestInfo:(NSString *)requestInfo {
    
    
    id info = requestInfo;
    if(requestInfo.length && !(info == [NSNull null])) {
        _requestInfo = requestInfo;
    } else {
        if (!_userName) {
            
            return;
        }
        _requestInfo = [NSString stringWithFormat:@"您好,我是%@...",_userName];
    }

    _requestInfolabel.text = _requestInfo;
}


- (CGFloat)heightWithText:(NSString *)requestInfo {
    
    CGFloat height = [requestInfo boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
    
    if (height > 20) {
        return 60 + height;
    }
    
    return 80;
}
@end
