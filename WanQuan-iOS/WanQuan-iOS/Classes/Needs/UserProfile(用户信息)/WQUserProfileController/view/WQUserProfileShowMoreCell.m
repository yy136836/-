//
//  WQUserProfileShowMoreCell.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQUserProfileShowMoreCell.h"
#import <NSAttributedString+YYText.h>
@interface WQUserProfileShowMoreCell()


@end


@implementation WQUserProfileShowMoreCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_showMoreButton addTarget:self
                        action:@selector(showMore:)
              forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.clipsToBounds = YES;
}

- (void)showMore:(UIButton *)sender {
    if (self.showMoreInfo) {
        self.showMoreInfo();
    }
}


@end
