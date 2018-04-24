//
//  WQNearbyroboneTabViewcell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 16/11/23.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "WQNearbyroboneTabViewcell.h"
#import "WQHomeNearby.h"
#import "WQUserProfileController.h"

@interface WQNearbyroboneTabViewcell () <UITextViewDelegate>
// 标题
@property (strong, nonatomic)  UILabel *subject;
// 内容
@property (strong, nonatomic)  UILabel *content;
// 金额
@property (strong, nonatomic)  UILabel *money;
// 开关
@property (strong, nonatomic)  UISwitch *anonymitySwitch;
@end

@implementation WQNearbyroboneTabViewcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
    }
    return self;
}

#pragma mark -- 初始化setupContentView
- (void)setupContentView {
    self.money = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x5288d8] andFontSize:24];
    [self.contentView addSubview:self.money];
    // 金额
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView).offset(-ghSpacingOfshiwu);
    }];
    
    self.subject = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:17];
    self.subject.numberOfLines = 0;
    [self.contentView addSubview:self.subject];
    // 标题
    [self.subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.money.mas_centerY);
        make.right.equalTo(self.contentView).offset(kScaleX(-75));
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(8));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.subject.mas_bottom).offset(ghSpacingOfshiwu);
        make.height.offset(0.5);
    }];
    
    // 详细内容
    self.content = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHex:0x333333] andFontSize:16];
    self.content.numberOfLines = 5;
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScaleY(ghSpacingOfshiwu));
        make.top.equalTo(lineView.mas_bottom).offset(ghSpacingOfshiwu);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 分隔线
    UIView *twoLineView = [[UIView alloc] init];
    twoLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:twoLineView];
    [twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.height.offset(ghStatusCellMargin);
        make.top.equalTo(self.content.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 匿名需求Label
    UILabel *tagLabel = [UILabel labelWithText:@"匿名接需求" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.contentView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left);
        make.top.equalTo(twoLineView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // Switch
    self.anonymitySwitch = [[UISwitch alloc] init];
    [self.anonymitySwitch addTarget:self action:@selector(switchAnonymous:) forControlEvents:UIControlEventValueChanged];
    self.anonymitySwitch.on = NO;
    self.anonymitySwitch.onTintColor = [UIColor colorWithHex:0x9767d0];
    [self.contentView addSubview:self.anonymitySwitch];
    [self.anonymitySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-ghSpacingOfshiwu);
    }];
    
    // 分隔线
    UIView *threeLineView = [[UIView alloc] init];
    threeLineView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.contentView addSubview:threeLineView];
    [threeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.height.offset(ghStatusCellMargin);
        make.top.equalTo(tagLabel.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 我的优势
    UILabel *advantageMeLabel = [UILabel labelWithText:@"我的优势" andTextColor:[UIColor colorWithHex:0x111111] andFontSize:16];
    [self.contentView addSubview:advantageMeLabel];
    [advantageMeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kScaleY(ghSpacingOfshiwu));
        make.top.equalTo(threeLineView.mas_bottom).offset(ghSpacingOfshiwu);
    }];
    
    // 输入的优势
    self.superiorityTextView = [[UITextView alloc] init];
    self.superiorityTextView.placeholder = @"填写我的优势; 建议您在被选为正式接单者前不要直接告诉对方答案";
    self.superiorityTextView.placeholderColor = [UIColor colorWithHex:0xb2b2b2];
    self.superiorityTextView.delegate = self;
    [self.superiorityTextView setFont:[UIFont systemFontOfSize:15]];
    self.superiorityTextView.returnKeyType = UIReturnKeyDefault;
    [self.contentView addSubview:self.superiorityTextView];
    [self.superiorityTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(advantageMeLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(11);
        make.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString * changedString=[[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    
    return YES;
}


- (void)setModel:(WQHomeNearby *)model {
    _model = model;
    self.subject.text = model.subject;
    self.content.text = model.content;
    //[self getAttributedStringWithString:model.content lineSpace:3];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥"
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.money]
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithHex:0x5288d8]}]];
    self.money.attributedText = str;
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)switchAnonymous:(UISwitch *)sender {
    
    if (![WQDataSource sharedTool].isVerified) {
        // 快速注册的用户
        UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"实名认证后可选择匿名"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 NSLog(@"取消");
                                                             }];
        UIAlertAction *destructiveButton = [UIAlertAction actionWithTitle:@"实名认证"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      NSLog(@"%@",[WQDataSource sharedTool].userIdString);
                                                                      WQUserProfileController *vc = [[WQUserProfileController alloc] initWithUserId:[WQDataSource sharedTool].userIdString];
                                                                      [self.viewController.navigationController pushViewController:vc animated:YES];
                                                                  }];
        [destructiveButton setValue:[UIColor colorWithHex:0x5d2a89] forKey:@"titleTextColor"];
        [cancelButton setValue:[UIColor colorWithHex:0x666666] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelButton];
        [alertController addAction:destructiveButton];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        [sender setOn:NO];
    }
    
    BOOL whetheranonymous;
    if (sender.isOn) {
        NSLog(@"打开了");
        whetheranonymous = YES;
        if (self.boolwhetheranonBlock) {
            self.boolwhetheranonBlock(whetheranonymous);
        }
    }else {
        NSLog(@"关闭了");
        whetheranonymous = NO;
        if (self.boolwhetheranonBlock) {
            self.boolwhetheranonBlock(whetheranonymous);
        }
    }
}

@end
