//
//  WQConversationListHeader.h
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConversationListHeaderButtonOnClick)();

@interface WQConversationListHeader : UIView

@property (weak, nonatomic) IBOutlet UIView *systemDot;

@property (weak, nonatomic) IBOutlet UIView *circleDot;
@property (weak, nonatomic) IBOutlet UILabel *lastSystemMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCircleMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSystemMessageTime;
@property (weak, nonatomic) IBOutlet UILabel *lastCircleMessageTime;

@property (weak, nonatomic) IBOutlet UIView *zanDot;
@property (weak, nonatomic) IBOutlet UILabel *lastZanMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastZanMessageTime;


@property (nonatomic, copy) ConversationListHeaderButtonOnClick systemMessageOnClick;
@property (nonatomic, copy) ConversationListHeaderButtonOnClick circleMessageOnClick;
@property (nonatomic, copy) ConversationListHeaderButtonOnClick zanMessageOnClick;


@end
