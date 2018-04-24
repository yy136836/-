//
//  WQTextField.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/5/25.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQTextField.h"

@interface WQTextField ()
@property (nonatomic, assign) titleType type;
@end

@implementation WQTextField

- (instancetype)initWithTitleType:(titleType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)setUpUI {
    
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (self.type == wenshi) {
        CGRect inset = CGRectMake(bounds.origin.x + 1, bounds.origin.y + 0.8, bounds.size.width -15, bounds.size.height);
        return inset;
    }else if (self.type == zhaoren) {
        CGRect inset = CGRectMake(bounds.origin.x + 1, bounds.origin.y + .9, bounds.size.width -15, bounds.size.height);
        return inset;
    }else if (self.type ==bangzhu){
        CGRect inset = CGRectMake(bounds.origin.x + 1, bounds.origin.y - 1.2, bounds.size.width -15, bounds.size.height);
        return inset;
    }else if (self.type ==BBS){
        CGRect inset = CGRectMake(bounds.origin.x + 1, bounds.origin.y - 1.2, bounds.size.width -15, bounds.size.height);
        return inset;
    }else{
        CGRect inset = CGRectMake(bounds.origin.x + 1, bounds.origin.y + 2, bounds.size.width -15, bounds.size.height);
        return inset;
    }
    
}

@end
