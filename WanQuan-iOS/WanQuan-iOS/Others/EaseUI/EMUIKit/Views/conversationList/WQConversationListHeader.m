//
//  WQConversationListHeader.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQConversationListHeader.h"

@interface WQConversationListHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *systemMessageImage;
@property (weak, nonatomic) IBOutlet UIImageView *circleMessageImage;

@property (weak, nonatomic) IBOutlet UIImageView *zanmessageImage;


@end


@implementation WQConversationListHeader


- (void)awakeFromNib {
    ROOT(root);
    [super awakeFromNib];
    _systemDot.layer.cornerRadius = 5;
    _systemDot.layer.masksToBounds = YES;
    _systemDot.hidden = !root.haveSystemInfoToDealWith;
    
    _circleDot.layer.cornerRadius = 5;
    _circleDot.layer.masksToBounds = YES;
    _circleDot.hidden = !root.haveCircleEvent;
    
    
    _zanDot.layer.cornerRadius = 5;
    _zanDot.layer.masksToBounds = YES;
    // TODO: 赞的红点还没写
    _zanDot.hidden = !root.haveLikeTodealWith;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot) name:WQShouldHideRedNotifacation object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOrShowDot) name:WQShouldShowRedNotifacation object:nil];

    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)hideOrShowDot {
//    ROOT(root);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        if (root) {
//            self.systemDot.hidden = !root.haveSystemInfoToDealWith;
//            self.circleDot.hidden = !root.haveCircleEvent;
//        }
//    });
//
//}


- (IBAction)systemMessageOnClick:(id)sender {
    _systemDot.hidden = YES;
    if (self.systemMessageOnClick) {
        self.systemMessageOnClick();
    }
}
- (IBAction)circleMessageOnClick:(id)sender {
    _circleDot.hidden = YES;
    if (self.circleMessageOnClick) {
        self.circleMessageOnClick();
    }
}
- (IBAction)zanMessageOnClick:(id)sender {
    _zanDot.hidden = YES;
    if (self.zanMessageOnClick) {
        self.zanMessageOnClick();
    }
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:WQShouldHideRedNotifacation object:nil];
//}
@end
