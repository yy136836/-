//
//  WQhelpView.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/9.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQhelpView.h"

@interface WQhelpView()

@end

@implementation WQhelpView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *oncLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.text = @"实名认证:";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(ghDistanceershi);
            make.left.equalTo(self).offset(ghSpacingOfshiwu);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *twoLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.attributedText = [self getAttributedStringWithString:@"1.问：为什么我需要填写实名信息，还需要实名认证后才能注册？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(oncLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *threeLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：为了确保用户能够放心使用、放心交易，本软件是实名注册软件，一人一号，必须认证了手机号、身份证和本人姓名一致才能使用。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(twoLabel.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fourLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"2.问：除了实名信息外，我还需填写哪些信息？还需要认证吗？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(threeLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fiveLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：进入万圈软件后，您可在“个人信息”页面填写您的学习和工作经历，请如实填写，万圈客服虽不进行认证，但所有您的好友会看到且可为您认证；每条信息由两位好友认证后才显示为“已认证”。\n认证学历和工作经历的好处主要为：\n一、其他用户与您交流时可能优先选择帮助经历认证过的可信用户。\n二、万圈会将把与您认证经历紧密相关的机会、需求信息优先推送给您。\n三、认证的经历信息可以增加您的万圈信用分数，所有用户都看到您是更可信的人。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fourLabel.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sixLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"3.问：我可以随便为别人认证信息为真实吗？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fiveLabel.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabel = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：不能。请务必只给您确保正确的信息进行认证，否则一旦该信息被证明或举报与实际有出入，您作为认证人也将会被扣除信用分，所有用户都可能看到您有失信记录；严重的情况甚至被注销万圈账号终身不能使用，且上其他合作征信机构的黑名单。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sixLabel.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    
    UILabel *Label1 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"信息安全:";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sevenLabel.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *twoLabea = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"1.问：所有人能看到我的实名信息吗？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Label1.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *threeLabel1 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：不能。一、所有用户既不能看到也不能搜索到您的手机号、身份证号、身份证照片等隐私信息。二、您的万圈好友可以看到您的真实姓名、头像、学历和工作经历。三、您在接发需求时如果选择匿名发布，其他人都看不到您的背景信息。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(twoLabea.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fourLabela = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"2.问：什么是匿名？";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(threeLabel1.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fiveLabela = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：非好友不能看到您的头像，您的名字也是匿名的；您每次选择匿名发布需求时，其他人将看到您显示名为匿名的需求。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fourLabela.mas_bottom).offset(3);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-20);
        }];
        label;
    });
    UILabel *sixLabela = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"3.问：我的信息会被泄露吗？";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fiveLabela.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabela = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：我们的后台数据经过多层加密，对隐私和信息进行加密的技术是万圈的优势之一，足以防止黑客攻击或木马。另外，客服人员只能看到您的小部分基本公开信息，并且所有员工都经过职业操守培训，签署了保密协议。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sixLabela.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fourLabela1 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"需求互助交易：";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sevenLabela.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *fiveLabela2 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"1.问：怎样完成一个完整的需求互助交易？";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fourLabela1.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sixLabela3 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：具体步骤如下：\n一、发需求者尽可能详细的填写需求信息，后点击“发布”，自愿出价的订单金额会被预冻结；如果无人接单，或者在设定的有效期间没找到自己认可的接单人，款项自动退还。\n二、接需求者看到需求后可咨询确认；也可根据真实情况陈述自我优势，并点击“我能帮助”加入抢单。\n三、发需求者从抢单人列表中选择自己认为最合适的接需求者，点击“选定他”。\n四、接需求者与发需求者可在需求页面“临时会话”处进行沟通互助。\n五、需求完成后接需求者可点“确认完成”。\n六、发需求者点“确认完成”，需求交易账款将自动转到接需求者账户；为了避免打扰，未加好友的用户之间将不能再通过需求页面聊天。\n七、在“已完成订单”处互相评价后（匿名的），双方的万圈信用分将有一定的增加或者降低。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fiveLabela2.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *sevenLabela4 = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"2.问：交易不满意怎么办？";
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sixLabela3.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *labell = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：用户间基于信任进行交易，选择互助交易对象前请仔细查看强担任的对方信用分和人脉关系远近谨慎选择，建议你在交易过程中请积极沟通。如果万一无法达成一致意见，请不要担心，发需求者钱款只是暂时冻结并没有转给接单者，发需求者在交易过程中随时可以点击“申请退款”按钮，客服将介入协助。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sevenLabela4.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *mmmmmm = ({
        UILabel *label = [[UILabel alloc ]init];
        label.text = @"万圈个人状态:";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:17];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labell.mas_bottom).offset(ghSpacingOfshiwu);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *mmmmm = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"1.问：我可以在万圈页面中发布任何个人状态吗？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mmmmmm.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *jhhhhhhh = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：万圈中可以放心发布您的个人状态，可以与您的好友进行互动。但是万圈中禁止发布政治、宗教信息、广告、和互助需求。互助需求只能在需求页面发布。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mmmmm.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *jhaaaaaaahhhhh = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"2.问：我在万圈中发布有益信息有奖励吗？" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(jhhhhhhh.mas_bottom).offset(ghStatusCellMargin);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *aaaaahhhhh = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"答：本软件鼓励大家多发对他人有帮助的信息，以提高自己的信任分和公众形象、才可获得万圈信用分高用户认可；\n请避免只发损人利己的信息，因为其他用户看到您的万圈好友圈分享可以点赞、点踩、评论、转发、打赏。\n请知会为他人点赞点踩将有现金奖惩，如果您看到他人发了让您不舒服的内容，可以点踩，对方将会因涉嫌滥用万圈被象征性扣除0.1元，您不会收到该0.1元，对方也看不到被谁踩的。" lineSpace:5];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHex:0x444444];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(jhaaaaaaahhhhh.mas_bottom).offset(5);
            make.left.equalTo(oncLabel.mas_left);
            make.right.equalTo(self).offset(-ghSpacingOfshiwu);
        }];
        label;
    });
    UILabel *ahhhhh = ({
        UILabel *label = [[UILabel alloc ]init];
        label.attributedText = [self getAttributedStringWithString:@"有更多问题需帮助可以直接与客服联系，发送邮件到service@belightinnovation.com" lineSpace:5];
        label.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aaaaahhhhh.mas_bottom).offset(25);
            make.left.equalTo(self.mas_left).offset(ghDistanceershi);
            make.right.equalTo(self).offset(-ghDistanceershi);
            make.bottom.equalTo(self.mas_bottom).offset(-ghDistanceershi);
        }];
        label;
    });
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

@end
