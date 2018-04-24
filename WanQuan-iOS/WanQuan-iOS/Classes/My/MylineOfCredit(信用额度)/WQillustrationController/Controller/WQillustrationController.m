//
//  WQillustrationController.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/4.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQillustrationController.h"

@interface QillustrationCell : UITableViewCell

@end

@implementation QillustrationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *iamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"illustration"] highlightedImage:0];
    [self addSubview:iamgeView];
    [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(ghSpacingOfshiwu);
        make.width.offset(iamgeView.bounds.size.width);
        make.height.offset(iamgeView.bounds.size.height);
    }];
    
    UILabel *oncLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"信用分总览：";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iamgeView.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
            make.left.equalTo(self.mas_left).offset(ghSpacingOfshiwu);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *twoLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"万圈信用分体现某用户个人在万圈的可信度，基于大数据用数学模型实时计算而成。万圈信用分范围0分-100分。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(oncLabel.mas_bottom).offset(kScaleX(5));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *threeLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"信用分作用:";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(twoLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fourLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"我们致力建立可靠可信的万圈信用体系，降低用户自己去辨别的复杂度、避免用户常规方法去打探推测可信度的低效率高成本，和消除因为信息不对称而未知的隐含风险。\n万圈信用分不仅仅反映用户财务状况，更多的反映了用户日常行为的可信度。\n在发需求、接需求时将作为重要的参考要素（建议您选择信用分高的用户进行交易），同时信用分的高低也将影响用户使用的权限。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(threeLabel.mas_bottom).offset(kScaleX(5));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fiveLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"信用分扣减：";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fourLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sixLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"触犯法律的行为、涉及宗教、政治导向、恐怖主义的言论等被严格禁止，视情节严重终止万圈使用权限甚至向相应机关举报。\n万圈信用分基于人与人的基本信任，任何被投诉或证实的失信行为：包括但不仅限于虚假信息、不负责言论、恶意欺骗等，无论造成的后果大小都将导致用户的\n万圈信用分被扣减和万圈内通报，甚至被终止万圈使用权限和通报其他征信平台。\n刷单、侵权、骚扰、诱导、语言暴力、泄露他人信息等行为都将被减少相应的信用分。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fiveLabel.mas_bottom).offset(kScaleX(5));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"信用分提升：";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sixLabel.mas_bottom).offset(kScaleX(ghSpacingOfshiwu));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    
    
    UILabel *Label1 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"万圈信用分由您的背景信息、日常行为记录等综合计算得出。\n结合社会道德共识，可以明确的是以下的一些操作可以提升您的信用和社会形象。\n1.	填写完整的个人信息，包括学习经历、工作经历等。\n2.	万圈好友或同一圈内用户为您的经历进行认证担保。\n3.	与其他用户互助共享、接单交易过程中诚实守信、及时、热情并完成对对方的评价。\n4.	在好友圈多分享对大家有帮助的干货信息，获他人赞赏；尽量不转发谣言、道德绑架等信息。\n5.	为万圈优化及更好的服务用户，多提供好的建议。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sevenLabel.mas_bottom).offset(kScaleX(5));
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
            make.bottom.equalTo(self.mas_bottom).offset(-ghDistanceershi);
        }];
        label;
    });
}

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    // 调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end

static NSString *cellid = @"cellid";

@interface WQillustrationController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WQillustrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationItem.title = @"提升信用";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbulan"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

#pragma mark -- 初始化UI
- (void)setupUI {
    UITableView *tableview = [[UITableView alloc]init];
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [tableview registerClass:[QillustrationCell class] forCellReuseIdentifier:cellid];
    tableview.dataSource = self;
    tableview.delegate = self;
    // 设置自动行高
    tableview.rowHeight = UITableViewAutomaticDimension;
    // 设置预估行高
    tableview.estimatedRowHeight = 1300;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(ghNavigationBarHeight);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kScaleX(1220);
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QillustrationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
