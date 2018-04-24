//
//  WQUserProfileCommonSectionHeaderView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileCommonSectionHeaderView.h"

@interface WQUserProfileCommonSectionHeaderView()



@end


@implementation WQUserProfileCommonSectionHeaderView


- (void)awakeFromNib {
    [super awakeFromNib];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subSwichDidOn:) name:WQUserProfileSubSwitchOnNoti object:nil];
    self.backgroundColor = [UIColor whiteColor];
}
- (CGFloat)headerHeightForHeaderConttent:(NSString *)conttent {
    
    _conttentLabel.text = conttent;
    CGSize size = [_conttentLabel sizeThatFits:CGSizeMake(kScreenWidth - 30, MAXFLOAT)];
    
//    描述为两行返回100
    if (size.height > 20) {
        return 105;
    }
//   否则返回85
    return 90;
}

//- (void)switchStateChanged:(WQSwitch *)aSwitch forEvent:(UIEvent *)event {

//}


- (IBAction)switchValueChanged:(WQSwitch *)sender forEvent:(UIEvent *)event {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:WQUserProfileMainSwitchStateDidChangeNoti
                                                            object:_switch1];
   
        sender.beOnWithNoti = NO;
}



- (void)subSwichDidOn:(NSNotification *)noti {
    if (!_switch1.on) {
        _switch1.on = YES;
        _switch1.beOnWithNoti = NO;
    }
}


- (IBAction)goRecommend:(id)sender {
    if (self.goRecommendPage) {
        self.goRecommendPage();
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
