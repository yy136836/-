//
//  WQNewGroupView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 2017/6/13.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQNewGroupView.h"

@interface WQNewGroupView () <UITextViewDelegate>

@end

@implementation WQNewGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupUI {
    // 群头像的标签
    UILabel *headTagLabel = [UILabel labelWithText:@"圈头像" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self addSubview:headTagLabel];
    
    [headTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kScaleX(ghDistanceershi));
        make.left.equalTo(self.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        make.height.offset(kScaleX(ghDistanceershi));
    }];
    
    // 右边的三角
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    [self addSubview:triangleImage];
    [triangleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(ghStatusCellMargin), kScaleX(12)));
        make.right.equalTo(self.mas_right).offset(kScaleY(-ghSpacingOfshiwu));
        make.centerY.equalTo(headTagLabel.mas_centerY);
    }];
    
    // 头像
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gerenjinglitouxiang"]];
    self.headImageView = headImageView;
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScaleY(40), kScaleX(40)));
        make.centerY.equalTo(triangleImage.mas_centerY);
        make.right.equalTo(triangleImage.mas_left).offset(kScaleY(-5));
    }];
    
    // 中间的一条线
    UIView *dividingLine = [[UIView alloc] init];
    dividingLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:dividingLine];
    [dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTagLabel.mas_left);
        make.top.equalTo(headTagLabel.mas_bottom).offset(kScaleX(ghDistanceershi));
        make.right.equalTo(self.mas_right);
        make.height.offset(0.5);
    }];
    
    // 点击头像那一栏的btn
    UIButton *headBtn = [[UIButton alloc] init];
    [headBtn addTarget:self action:@selector(headBtnClike) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headBtn];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(dividingLine.mas_bottom);
        make.height.offset(50);
    }];
    
    UILabel *nameLabel = [UILabel labelWithText:@"圈名称" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    nameLabel.frame = CGRectMake(0, 0, kScaleY(60), kScaleX(ghDistanceershi));
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTagLabel.mas_left);
        make.top.equalTo(dividingLine.mas_bottom).offset(kScaleX(15));
    }];
    
    // 群名的输入框
    UITextField *nameInputBoxTextField = [[UITextField alloc] init];
    self.nameInputBoxTextField = nameInputBoxTextField;
    nameInputBoxTextField.font = [UIFont systemFontOfSize:15];
    nameInputBoxTextField.textColor = [UIColor colorWithHex:0x333333];
    nameInputBoxTextField.placeholder = @"请填写圈名称（2~14个字）";
    [nameInputBoxTextField setValue:[UIColor colorWithHex:0x999999] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:nameInputBoxTextField];
    [nameInputBoxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).offset(10);
        make.height.offset(kScaleX(50));
    }];
    
    // 第二条分隔线
    UIView *dividingTwoLine = [[UIView alloc] init];
    dividingTwoLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self addSubview:dividingTwoLine];
    [dividingTwoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTagLabel.mas_left);
        make.top.equalTo(nameInputBoxTextField.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.offset(0.5);
    }];
    
    // 输入简介
    UITextView *contentTextView = [[UITextView alloc] init];
    self.contentTextView = contentTextView;
    contentTextView.delegate = self;
    [contentTextView setFont:[UIFont systemFontOfSize:15]];
    contentTextView.placeholder = @"快来介绍一下此群,让更多的人了解并加入,结识更多的伙伴~";
    contentTextView.placeholderColor = [UIColor colorWithHex:0x999999];
    [self addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dividingTwoLine.mas_bottom);
        make.left.equalTo(headTagLabel.mas_left).offset(kScaleY(-2));
        make.right.equalTo(self.mas_right);
        make.height.offset(kScaleX(190));
    }];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGestureDown];
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGestureUp];

}

//轻扫手势触发方法
-(void)swipeGesture:(id)sender {
    [self.nameInputBoxTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameInputBoxTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

// 头像一栏的响应事件
- (void)headBtnClike {
    [BDImagePicker showImagePickerFromViewController:self.viewController allowsEditing:YES finishAction:^(UIImage *image) {
        if (!image) {
            return ;
        }
        self.headImageView.image = image;
    }];
}

#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    
    return YES;
}

@end
