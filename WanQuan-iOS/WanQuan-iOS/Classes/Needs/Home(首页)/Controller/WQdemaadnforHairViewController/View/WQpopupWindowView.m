//
//  WQpopupWindowView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/4/10.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQpopupWindowView.h"
#import "WQRemunerationCollectionViewCell.h"

static NSString *identifier = @"identifier";

@interface WQpopupWindowView () <UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *moneyString;

/**
 交易人数
 */
@property (nonatomic, strong) UITextField *presonNumberTextField;

/**
 总金额
 */
@property (nonatomic, strong) UILabel *totalMoneyLabel;

/**
 金额的输入框
 */
@property (nonatomic, strong) UITextField *moneyTextField;

/**
 加号的按钮
 */
@property (nonatomic, strong) UIButton *addBtn;

/**
 减号的按钮
 */
@property (nonatomic, strong) UIButton *reductionBtn;

/**
 交易人数  ||  红包个数
 */
@property (nonatomic, strong) UILabel *presonNumberTextLabel;

/**
 白色背景view
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 需求报酬
 */
@property (nonatomic, strong) UILabel *textLabel;

/**
 单人报酬
 */
@property (nonatomic, strong) UILabel *remunerationLabel;

/**
 总金额
 */
@property (nonatomic, copy) NSString *totalString;

/**
 弹出键盘时带有完成的view
 */
@property (nonatomic, strong) UIView *keyboardView;

@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) NSString *titleString;

@end

@implementation WQpopupWindowView {
    BOOL isHaveDian;
    NSArray *itmeArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleString = @"10";
        self.totalString = @"10";
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithWhite:0x000000 alpha:0.4];
        [self setupUI];
        
        // 注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 监听通知
- (void)keyboardWasShown:(NSNotification *)noti {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *userInfo = noti.userInfo;
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.keyboardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.bottom.equalTo(self.mas_bottom).offset(-rect.size.height);
        make.left.right.equalTo(self);
    }];
    
    if (self.moneyTextField.isFirstResponder) {
        
//        [self.moneyTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(43);
//            make.bottom.equalTo(self.mas_bottom).offset(-rect.size.height - 50);
//            make.left.right.equalTo(self.collectionView);
//        }];
//        [UIView animateWithDuration:0.5 animations:^{
//            [weakSelf layoutIfNeeded];
//        }];
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-rect.size.height);
            make.height.offset(372);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf layoutIfNeeded];
        }];
    }
    
    if (self.presonNumberTextField.isFirstResponder) {
        self.remunerationLabel.hidden = YES;
//        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-rect.size.height - 50);
//            make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
//            make.size.mas_equalTo(CGSizeMake(28, 28));
//        }];
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-rect.size.height);
            make.height.offset(372);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf layoutIfNeeded];
        }];
    }
}

- (void)keyBoardWillHidden:(NSNotification *)noti {
    
    __weak typeof(self) weakSelf = self;
    
    self.remunerationLabel.hidden = NO;
    [self.keyboardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.bottom.equalTo(self.mas_bottom).offset(50);
        make.left.right.equalTo(self);
    }];
//    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.moneyTextField.mas_bottom).offset(ghDistanceershi);
//        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
//        make.size.mas_equalTo(CGSizeMake(28, 28));
//    }];
    
//    [self.moneyTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.collectionView.mas_bottom).offset(ghStatusCellMargin);
//        make.left.right.equalTo(self.collectionView);
//        make.height.offset(43);
//    }];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.offset(372);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf layoutIfNeeded];
    }];
    [self completeBtnClick];
}

- (void)selfClick {
    self.hidden = !self.hidden;
    [self endEditing:YES];
    NSString *moneyString;
    if ([self.moneyTextField.text  isVisibleString]) {
        moneyString = self.moneyTextField.text;
    }else {
        moneyString = self.titleString;
    }
    if ([self.delegate respondsToSelector:@selector(wqDetermineBtnClick:totalString:personNum:moneyString:)]) {
        [self.delegate wqDetermineBtnClick:self totalString:self.totalString personNum:self.presonNumberTextField.text moneyString:moneyString];
    }
}

- (void)backgroundViewClick {
    [self endEditing:YES];
}

#pragma mark - 初始化UI
- (void)setupUI {
    UIView *backgroundView = [[UIView alloc] init];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewClick)];
    [backgroundView addGestureRecognizer:tap];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.offset(372);
    }];
    
    UILabel *textLabel = [UILabel labelWithText:@"需求报酬" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.textLabel = textLabel;
    textLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
    [backgroundView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(backgroundView.mas_top).offset(17);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [backgroundView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(0.5);
        make.top.equalTo(textLabel.mas_bottom).offset(17);
    }];
    
    UILabel *remunerationLabel = [UILabel labelWithText:@"单人报酬" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.remunerationLabel = remunerationLabel;
    self.remunerationLabel = remunerationLabel;
    [backgroundView addSubview:remunerationLabel];
    [remunerationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(lineView.mas_left).offset(ghSpacingOfshiwu);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.userInteractionEnabled = YES;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor colorWithHex:0xffffff];
    // 禁止滑动
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WQRemunerationCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remunerationLabel.mas_bottom).offset(ghSpacingOfshiwu);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
        make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        make.height.offset(98);
    }];
    
    UITextField *moneyTextField = [[UITextField alloc] init];
    self.moneyTextField = moneyTextField;
    moneyTextField.placeholder = @"  ¥ 自定义金额";
    moneyTextField.font = [UIFont systemFontOfSize:17];
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextField.returnKeyType = UIReturnKeyDone;
    moneyTextField.textColor = [UIColor colorWithHex:0X333333];
    moneyTextField.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    moneyTextField.layer.borderWidth = 1.0f;
    moneyTextField.layer.cornerRadius = 5;
    moneyTextField.borderStyle = UITextBorderStyleRoundedRect;
    moneyTextField.layer.masksToBounds = YES;
    moneyTextField.delegate = self;
    [self addSubview:moneyTextField];
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(ghStatusCellMargin);
        make.left.right.equalTo(collectionView);
        make.height.offset(43);
    }];
    
    UILabel *yuanLabel = [UILabel labelWithText:@"元    " andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    moneyTextField.rightView = yuanLabel;
    moneyTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *addBtn = [[UIButton alloc] init];
    self.addBtn = addBtn;
    addBtn.layer.borderColor = [UIColor colorWithHex:0xefe9fc].CGColor;
    addBtn.layer.borderWidth = 1.0f;
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.masksToBounds = YES;
    [addBtn setImage:[UIImage imageNamed:@"baochoujia"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextField.mas_bottom).offset(ghDistanceershi);
        make.right.equalTo(self.mas_right).offset(-ghSpacingOfshiwu);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    UITextField *presonNumberTextField = [[UITextField alloc] init];
    self.presonNumberTextField = presonNumberTextField;
    presonNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    presonNumberTextField.delegate = self;
    presonNumberTextField.textAlignment = NSTextAlignmentCenter;
    presonNumberTextField.layer.borderWidth = 0.0f;
    presonNumberTextField.layer.cornerRadius = 0;
    presonNumberTextField.layer.borderColor = [UIColor clearColor].CGColor;
    presonNumberTextField.text = @"1";
    [self addSubview:presonNumberTextField];
    [presonNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.equalTo(addBtn.mas_left);
        make.centerY.equalTo(addBtn.mas_centerY);
    }];
    
    UIButton *reductionBtn = [[UIButton alloc] init];
    self.reductionBtn = reductionBtn;
    reductionBtn.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    reductionBtn.layer.borderWidth = 1.0f;
    reductionBtn.layer.cornerRadius = 3;
    reductionBtn.layer.masksToBounds = YES;
    [reductionBtn setImage:[UIImage imageNamed:@"baochoujian"] forState:UIControlStateNormal];
    [reductionBtn setTitleColor:[UIColor colorWithHex:0xb2b2b2] forState:UIControlStateNormal];
    [reductionBtn addTarget:self action:@selector(reductionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reductionBtn];
    [reductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.right.equalTo(presonNumberTextField.mas_left);
        make.centerY.equalTo(presonNumberTextField.mas_centerY);
    }];
    
    UILabel *presonNumberTextLabel = [UILabel labelWithText:@"交易人数" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:17];
    self.presonNumberTextLabel = presonNumberTextLabel;
    [self addSubview:presonNumberTextLabel];
    [presonNumberTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addBtn.mas_centerY);
        make.left.equalTo(self).offset(ghSpacingOfshiwu);
    }];
    
    UIButton *determineBtn = [[UIButton alloc] init];
    determineBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    determineBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determineBtn addTarget:self action:@selector(determineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:determineBtn];
    [determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.offset(kScreenWidth * 0.5);
        make.bottom.right.equalTo(self);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(determineBtn.mas_top);
        make.height.offset(1);
        make.left.right.equalTo(self);
    }];
    
    UILabel *totalMoneyLabel = [[UILabel alloc] init];
    self.totalMoneyLabel = totalMoneyLabel;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"总金额:  "               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],                                           NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"10"                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26],                   NSForegroundColorAttributeName:[UIColor colorWithHex:0x9767d0]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"  元"               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],                                           NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]}]];
    totalMoneyLabel.attributedText = str;
    [self addSubview:totalMoneyLabel];
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(determineBtn.mas_centerY);
        make.left.equalTo(self).offset(kScaleX(32));
    }];
    
    UIView *keyboardView = [[UIView alloc] init];
    keyboardView.backgroundColor = [UIColor whiteColor];
    self.keyboardView = keyboardView;
    [self addSubview:keyboardView];
    [keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.bottom.equalTo(self).offset(50);
        make.left.right.equalTo(self);
    }];
    
    UIButton *completeBtn = [[UIButton alloc] init];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [keyboardView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(keyboardView.mas_centerY);
        make.right.equalTo(keyboardView).offset(-ghDistanceershi);
    }];
}

#pragma mark -- 完成的响应事件
- (void)completeBtnClick {
    [self endEditing:YES];
    if (self.isBBS) {
        // 总额
        if (!self.moneyString.length && !self.presonNumberTextField.text.length) {
            self.totalString = @"10";
        }else {
            NSString *numberOfTraders;
            CGFloat aSinglePayment = [self.presonNumberTextField.text floatValue];
            if (self.moneyTextField.text.length) {
                numberOfTraders = self.moneyTextField.text;
            }else {
                numberOfTraders = self.titleString;
            }
            self.totalString = [NSString stringWithFormat:@"%.1f",numberOfTraders.floatValue * aSinglePayment];
        }
    }else {
        if (!self.moneyString.length && !self.presonNumberTextField.text.length) {
            self.totalString = @"10";
        }else {
            NSString *numberOfTraders;
            NSInteger aSinglePayment = [self.presonNumberTextField.text integerValue];
            if (self.moneyTextField.text.length) {
                numberOfTraders = self.moneyTextField.text;
            }else {
                numberOfTraders = self.titleString;
            }
            self.totalString = [NSString stringWithFormat:@"%zd",numberOfTraders.integerValue * aSinglePayment];
        }
    }
}

- (void)setIsBBS:(BOOL)isBBS {
    _isBBS = isBBS;
    if (isBBS) {
        self.titleString = @"0.1";
        itmeArray = @[@"0.1",@"0.5",@"1",@"2",@"5",@"10"];
        self.textLabel.text = @"红包金额";
        self.remunerationLabel.text = @"单个红包金额";
        self.presonNumberTextField.text = @"100";
        self.presonNumberTextLabel.text = @"红包个数";
        self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.collectionView reloadData];
    }else {
        itmeArray = @[@"10",@"20",@"30",@"50",@"100",@"200"];
        [self.collectionView reloadData];
    }
}

- (void)setTotalString:(NSString *)totalString {
    _totalString = totalString;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"总金额:  "               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],                                           NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",totalString]                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26],                   NSForegroundColorAttributeName:[UIColor colorWithHex:0x9767d0]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"  元"               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],                                           NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]}]];
    self.totalMoneyLabel.attributedText = str;
}

#pragma mark -- 确定的响应事件
- (void)determineBtnClick {
    NSString *moneyString;
    if ([self.moneyTextField.text  isVisibleString]) {
        moneyString = self.moneyTextField.text;
    }else {
        moneyString = self.titleString;
    }
    if ([self.delegate respondsToSelector:@selector(wqDetermineBtnClick:totalString:personNum:moneyString:)]) {
        [self.delegate wqDetermineBtnClick:self totalString:self.totalString personNum:self.presonNumberTextField.text moneyString:moneyString];
    }
}

#pragma mark -- 加号的响应事件
- (void)addBtnClick{
    NSInteger personNum = [self.presonNumberTextField.text integerValue];
    personNum++;
    self.presonNumberTextField.text = [NSString stringWithFormat:@"%zd",personNum];
    
    // 总额
    NSString *totalString;
    if ([self.moneyTextField.text  isVisibleString]) {
        if (self.isBBS) {
            CGFloat i = [self.moneyTextField.text floatValue];
            CGFloat w = [[NSString stringWithFormat:@"%zd",personNum] floatValue];
            // 总额
            totalString = [NSString stringWithFormat:@"%.1f",i * w];
        }else {
            NSInteger i = [self.moneyTextField.text integerValue];
            totalString = [NSString stringWithFormat:@"%zd",i * personNum];
        }
    }else {
        if (self.isBBS) {
            CGFloat i = [self.titleString floatValue];
            CGFloat w = [[NSString stringWithFormat:@"%zd",personNum] floatValue];
            // 总额
            totalString = [NSString stringWithFormat:@"%.1f",i * w];
        }else {
            NSInteger i = [self.titleString integerValue];
            totalString = [NSString stringWithFormat:@"%zd",i * personNum];
        }
    }
    
    self.totalString = totalString;
}

#pragma mark -- 减号的响应事件
- (void)reductionBtnClick {
    if ([self.presonNumberTextField.text isEqualToString:@"1"]) {
        return;
    }
    NSInteger personNum = [self.presonNumberTextField.text integerValue];
    if (personNum <= 0) {
        return;
    }
    personNum--;
    self.presonNumberTextField.text = [NSString stringWithFormat:@"%zd",personNum];
    
    // 总额
    NSString *totalString;
    
    if ([self.moneyTextField.text  isVisibleString]) {
        if (self.isBBS) {
            CGFloat i = [self.moneyTextField.text floatValue];
            CGFloat w = [[NSString stringWithFormat:@"%zd",personNum] floatValue];
            // 总额
            totalString = [NSString stringWithFormat:@"%.1f",i * w];
        }else {
            NSInteger i = [self.moneyTextField.text integerValue];
            totalString = [NSString stringWithFormat:@"%zd",i * personNum];
        }
    }else {
        if (self.isBBS) {
            CGFloat i = [self.titleString floatValue];
            CGFloat w = [[NSString stringWithFormat:@"%zd",personNum] floatValue];
            // 总额
            totalString = [NSString stringWithFormat:@"%.1f",i * w];
        }else {
            NSInteger i = [self.titleString integerValue];
            totalString = [NSString stringWithFormat:@"%zd",i * personNum];
        }
    }
    
    self.totalString = totalString;
}

#pragma makr -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itmeArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(108, 44);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQRemunerationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleString = itmeArray[indexPath.item];
    
    if (indexPath.item == 0) {
        cell.titleBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        [cell.titleBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    }
    if (self.index.row == indexPath.row) {
        cell.titleBtn.backgroundColor = [UIColor colorWithHex:0x9767d0];
        [cell.titleBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    }else {
        cell.titleBtn.backgroundColor = [UIColor whiteColor];
        [cell.titleBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }
    
    if (self.moneyString.length) {
        cell.titleBtn.backgroundColor = [UIColor whiteColor];
        [cell.titleBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }
    
    __weak typeof(cell) weakCell = cell;
    [cell setTitleBtnClickBlock:^{
        self.moneyTextField.text = @"";
        self.moneyString = @"";
        [self.moneyTextField resignFirstResponder];
        self.index = indexPath;
        [collectionView reloadData];
        self.titleString = weakCell.titleString;
        // 总额
        NSString *totalString;
        if (self.isBBS) {
            CGFloat i = [weakCell.titleString floatValue];
            CGFloat w = [self.presonNumberTextField.text floatValue];
            // 总额
            totalString = [NSString stringWithFormat:@"%.1f",i * w];
        }else {
            NSInteger i = [weakCell.titleString integerValue];
            NSInteger w = [self.presonNumberTextField.text integerValue];
            totalString = [NSString stringWithFormat:@"%zd",i * w];
        }
        self.totalString = totalString;
    }];
    
    return cell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.moneyTextField) {
        self.moneyString = [self.moneyTextField.text stringByReplacingCharactersInRange:range withString:string];
        [self.collectionView reloadData];
    }
    if(((string.intValue < 0) || (string.intValue > 9))){
        if ((![string isEqualToString:@"."])) {
            return NO;
        }
        return NO;
    }
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger dotNum = 0;
    NSInteger flag = 0;
    const NSInteger limited = 1;
    if((int)futureString.length >= 1){
        
        if([futureString characterAtIndex:0] == '.'){
            return NO;
        }
        if((int)futureString.length >= 2){
            if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                return NO;
            }
        }
    }
    NSInteger dotAfter = 0;
    for (int i = (int)futureString.length - 1; i >= 0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            dotNum++;
            dotAfter = flag + 1;
            if (flag > limited) {
                return NO;
            }
            if(dotNum > 1){
                return NO;
            }
        }
        flag++;
    }
    
    return YES;
}

@end
