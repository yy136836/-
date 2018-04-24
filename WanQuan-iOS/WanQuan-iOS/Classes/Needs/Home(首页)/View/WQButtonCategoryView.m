//
//  WQButtonCategoryView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/1.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQButtonCategoryView.h"

@interface WQButtonCategoryView ()<UISearchBarDelegate>

@end

@implementation WQButtonCategoryView {
    NSArray <UIButton *>*_btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHex:0xfafafa];
    // 设置三个的按钮
    UIButton *subscribeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    subscribeBtn.tag = 2;
    [subscribeBtn setTitle:@"订阅" forState:UIControlStateNormal];
    [subscribeBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    subscribeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.tag = 1;
    [rightBtn setTitle:@"最新" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.tag = 0;
    [leftBtn setTitle:@"附近" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //添加三个按钮
    [self addSubview:subscribeBtn];
    [self addSubview:rightBtn];
    [self addSubview:leftBtn];
    
    _btnArray = @[leftBtn,rightBtn,subscribeBtn];
    [_btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:kScaleX(40) leadSpacing:kScaleX(40) tailSpacing:kScaleX(40)];
    [_btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-7);
    }];
    
    // 添加点击事件
    [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [subscribeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    //地图的按钮
//    UIButton *mapBtn = [[UIButton alloc]init];
//    [mapBtn setImage:[UIImage imageNamed:@"fujinweizhi"] forState:UIControlStateNormal];
//    [mapBtn addTarget:self action:@selector(mapBtnClike:) forControlEvents:UIControlEventTouchUpInside];
//    self.mapBtn = mapBtn;
//    
//    [self addSubview:mapBtn];
//    self.mapBtn.hidden = YES;
//    
//    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(leftBtn.mas_centerY).offset(3);
//        make.left.equalTo(self).offset(15);
//    }];
//    
//    //输入板的按钮
//    UIButton *srbBtn = [[UIButton alloc]init];
//    [srbBtn setImage:[UIImage imageNamed:@"dingyue"] forState:UIControlStateNormal];
//    self.srbBtn = srbBtn;
//    [srbBtn addTarget:self action:@selector(subscribeBtnClikemyInformation:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:srbBtn];
//    _srbBtn.hidden = YES;
//    
//    [srbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.centerY.equalTo(leftBtn.mas_centerY);
//    }];
//    
//    //搜索的按钮
//    UIButton *shousuoBtn = [[UIButton alloc]init];
//    [shousuoBtn setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateNormal];
//    _shousuoBtn = shousuoBtn;
//    [shousuoBtn addTarget:self action:@selector(shousuoBtnClike:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shousuoBtn];
//    
//    [shousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-25);
//        make.centerY.equalTo(leftBtn.mas_centerY);
//    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.btnCGfloat = _btnArray[0].frame.size.width + kScaleX(40);
}

- (void)BtnClick:(UIButton *)sender {
    if (self.BtnClickBlock) {
        self.BtnClickBlock(sender.tag);
    }
    //如果是附近页面就显示地图按钮
    if (sender.tag == 0) {
        self.mapBtn.hidden = NO;
    }else{
        self.mapBtn.hidden = YES;
    }
    //如果是订阅界面就显示输入框按钮
    if (sender.tag == 2) {
        _srbBtn.hidden = NO;
        _shousuoBtn.hidden = YES;
        _searchBar.hidden = YES;
    }else{
        _shousuoBtn.hidden = NO;
        _srbBtn.hidden = YES;
        _searchBar.hidden = NO;
    }
}

- (void)mapBtnClike:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeMapView:didClickAddButton:)]) {
        [self.delegate homeMapView:self didClickAddButton:sender];
    }
}

- (void)subscribeBtnClikemyInformation:(id)sender {
    NSLog(@"点击了订阅");
    if ([self.delegate respondsToSelector:@selector(myLFmyMineBalanceCell:didClickAddButton:)]) {
        [self.delegate myLFmyMineBalanceCell:self didClickAddButton:sender];
    }
}

- (void)shousuoBtnClike:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shousuoBtnClike:didClickAddButton:)]) {
        [self.delegate shousuoBtnClike:self didClickAddButton:sender];
    }
}

@end
