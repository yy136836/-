//
//  WQProfileLinkView.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/12/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQProfileLinkView.h"

@interface WQProfileLinkView()



@end

@implementation WQProfileLinkView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = HEX(0xf3f3f3);
        _linkImageView = [[UIImageView alloc] init];
        _linkImageView.backgroundColor = HEX(0xd8d8d8);
        [self addSubview:_linkImageView];
        [_linkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(@0);
            make.width.equalTo(@60);
        }];

        
        _linkTextlabel = [[UILabel alloc] init];
        [self addSubview:_linkTextlabel];
        [_linkTextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_linkImageView.mas_right).offset(15);
            make.top.bottom.right.equalTo(@0);
            make.right.equalTo(@-15);
        }];
        _linkTextlabel.font = [UIFont systemFontOfSize:16];
        _linkTextlabel.textColor = HEX(0x333333);
        _linkTextlabel.numberOfLines = 2;
    }
    return self;
}


@end
