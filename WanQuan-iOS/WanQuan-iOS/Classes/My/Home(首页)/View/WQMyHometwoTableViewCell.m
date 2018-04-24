//
//  WQMyHometwoTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQMyHometwoTableViewCell.h"
#import "WQMyHomeModel.h"

@interface WQMyHometwoTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@end

@implementation WQMyHometwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redDotView.layer.cornerRadius = 3;
    self.redDotView.layer.masksToBounds = YES;
//    self.lineView.layer.cornerRadius = 0;
//    self.lineView.layer.borderWidth = 1.0f;
//    self.lineView.layer.cornerRadius = 5;
//    self.lineView.layer.borderColor = [UIColor colorWithHex:0Xcbcbcb].CGColor;
//    self.lineView.backgroundColor = [UIColor colorWithHex:0xcbcbcb];
    _height.constant = 0.5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHideRedDot:) name:WQShouldShowRedNotifacation object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHideRedDot:) name:WQRecieveFriendRequestNotifacation object:nil];
    
}

- (void)setMyModel:(WQMyHomeModel *)myModel
{
    _myModel = myModel;
    self.myName.text = myModel.Myname;
    self.titleImage.image = [UIImage imageNamed:myModel.picture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showOrHideRedDot:(NSNotification *)notification {
    
    EMMessage * message =  notification.userInfo[@"message"];
    
    
  
    if ([self.myName.text isEqualToString:@"我发的需求"]) {
        
        if ([WQUnreadMessageCenter MYBILL_haveUnreadBidChatWithMyId:message.to] ) {
            self.redDotView.hidden = NO;
        } else {
            self.redDotView.hidden = YES;
        }
    } else if ([self.myName.text isEqualToString:@"我接的需求"]) {
        
        if ([WQUnreadMessageCenter  OTHERSBILL_haveUnreadBidingChatWithMyId:message.to] ) {
            self.redDotView.hidden = NO;
        } else {
            self.redDotView.hidden = YES;
        }
    } else if ([self.myName.text isEqualToString:@"我询问的需求"]){
        bool haveRed = [WQUnreadMessageCenter haveUnreadTemChatITalkedTo];
        self.redDotView.hidden = !haveRed;
    } else if ([self.myName.text isEqualToString:@"我的好友"]) {
        
        self.redDotView.hidden = ![WQContactManager haveUnacceptedFriendRequest];
    }
    
    
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldShowRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQRecieveFriendRequestNotifacation object:nil];
}
@end
