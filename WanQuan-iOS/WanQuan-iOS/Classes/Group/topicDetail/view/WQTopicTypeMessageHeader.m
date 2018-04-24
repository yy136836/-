//
//  WQTopicTypeMessageHeader.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/9/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTopicTypeMessageHeader.h"

@implementation WQTopicTypeMessageHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)showTopicInfo:(id)sender {
    if (self.ontap) {
        self.ontap();
    }
}
@end
