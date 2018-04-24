//
//  WQActionSheet.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/4.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQActionSheet.h"

@interface WQActionSheet ()
{
    NSInteger _nameCount;
}
@property (nonatomic,retain)UIView *bgView;

@end


@implementation WQActionSheet

-(instancetype)initWithTitles:(NSArray *)names
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = UIColorWithHex16_Alpha(0x000000, 0.4);
        [self addSubview:self.bgView];
        _nameCount=names.count;
        
        NSMutableArray *btnArray = [[NSMutableArray alloc]initWithCapacity:names.count];
        for(int i=0; i<names.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:names[i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0,i*50,kScreenWidth,50);
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [btn setTitleColor:WQ_TEXT_COLOR_DARK_BLACK forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [self.bgView addSubview:btn];
            [btnArray addObject:btn];
            
            if (i != 0) {
                UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0,i*(50), kScreenWidth, 1)];
                lineLB.backgroundColor = WQ_SEPARATOR_COLOR;
                [self.bgView addSubview:lineLB];
            }
        }
        
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismis)];
        [self addGestureRecognizer:tapAction];
        
        
        
        
    }
    return self;
}


- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50*_nameCount)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


- (void)btnClicked:(UIButton *)b
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedButton:ClickedName:)]) {
        [_delegate clickedButton:self ClickedName:b.titleLabel.text];
        [self dismis];
    }
}





- (void)show {
    self.frame=[UIScreen mainScreen].bounds;
    [kAppWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame =CGRectMake(0, kScreenHeight-50*_nameCount, kScreenWidth, 50*_nameCount);
    }];}




- (void)dismis {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.frame =CGRectMake(0, kScreenHeight, kScreenWidth, 50*_nameCount);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
