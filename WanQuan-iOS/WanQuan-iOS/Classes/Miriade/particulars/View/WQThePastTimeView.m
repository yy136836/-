//
//  WQThePastTimeView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/17.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQThePastTimeView.h"

@interface WQThePastTimeView()
@property (nonatomic, strong) UILabel *thePastTimeLabel;
@end

@implementation WQThePastTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    [self addSubview:self.thePastTimeLabel];
    [self addSubview:self.deleteBtn];
    
    [_thePastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_thePastTimeLabel.mas_centerY);
        make.left.equalTo(_thePastTimeLabel.mas_right).offset(18);
    }];
}

- (void)setThePastTime:(NSInteger)thePastTime {
    _thePastTime = thePastTime;
    NSInteger time = thePastTime;
    if (time < 60) {
        _thePastTimeLabel.text = [NSString stringWithFormat:@"刚刚"];
    }else if (time < 3600) {
        _thePastTimeLabel.text = [NSString stringWithFormat:@"%zd 分钟前",time / 60];
    }else if (time / (60 * 60 * 24) >= 1) {
        _thePastTimeLabel.text = [NSString stringWithFormat:@"%zd 天前",time / (60 * 60 * 24)];
    }else{
        _thePastTimeLabel.text = [NSString stringWithFormat:@"%zd 小时前",time / 3600];
    }
}

// 删除按钮响应事件
- (void)deleteBtnClike {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除此条万圈"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"取消");
                                                         }];
    UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"删除"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSLog(@"删除");
                                                                  if (self.deleteBtnClikeBlock) {
                                                                      self.deleteBtnClikeBlock();
                                                                  }
                                                              }];
    [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
    [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
    //alertController.view.tintColor = [UIColor colorWithHex:0x666666];
    
    [alertController addAction:cancelButton];
    [alertController addAction:destructiveButton];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 懒加载
- (UILabel *)thePastTimeLabel {
    if (!_thePastTimeLabel) {
        _thePastTimeLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x666666] andFontSize:11];
    }
    return _thePastTimeLabel;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton setNormalTitle:@"删除" andNormalColor:[UIColor colorWithHex:0X417dcc] andFont:11];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
