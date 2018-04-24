//
//  WQEssencePraiseView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/11/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQEssencePraiseView.h"

@implementation WQEssencePraiseView

- (IBAction)zanOnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQEssencePraiseViewZanOnClick:)]) {
        [self.delegate WQEssencePraiseViewZanOnClick:sender];
    }
}

- (IBAction)guliOnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(WQEssencePraiseViewZanOnClick:)]) {
        [self.delegate WQEssencePraiseViewPraiseOnClick:sender];
    }
}

@end
