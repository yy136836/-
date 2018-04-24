//
//  WQMessageNoLoginView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/7/19.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQMessageNoLoginView.h"
#import "WQLogInController.h"

@implementation WQMessageNoLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)loginOnClick:(id)sender {
    
      WQLogInController *vc = [[WQLogInController alloc] initWithTouristLoginStatus:TouristLoginStatusHide];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
