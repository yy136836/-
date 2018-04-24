//
//  WQaddWorkTableViewCell.m
//  WanQuan-iOS
//
//  Created by 郭杭 on 17/1/15.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQaddWorkTableViewCell.h"

@interface WQaddWorkTableViewCell() <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *workPlaceField;
@property (nonatomic, retain) UITableView * callWordTableView;
@property (nonatomic, retain) NSURLSessionDataTask * callWordTask;
@property (nonatomic, retain) NSMutableArray * callWords;
@end

@implementation WQaddWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    _workPlaceField.delegate = self;
    _callWords = @[].mutableCopy;
}

- (void)textFieldDidEndEditingNotification:(NSNotification *)sender {
    [self textFieldDidEndEditing:self.gongsimingcheng];
    [self textFieldDidEndEditing:self.zhiweimingcheng];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == _workPlaceField) {
        
        
        NSString * replaceStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        UITextRange *selectedTextRange = [textField markedTextRange];
//        NSString * newText = [textField textInRange:selectedTextRange];
//
////        NSString * fieldText = textField.text;
//        NSRange selectedRange = [replaceStr rangeOfString:newText];
//
//        NSString * inputDoneText;
//        if (selectedRange.location != NSNotFound) {
//            inputDoneText = [replaceStr stringByReplacingCharactersInRange:selectedRange withString:@""];
//        } else {
//            inputDoneText = replaceStr;
//        }
//
//        if (inputDoneText.length <= 1) {
//            _callWordTableView.hidden = YES;
//            [_callWords removeAllObjects];
//            return YES;
//        }


        if (replaceStr.length < 2) {
            _callWordTableView.hidden = YES;
        }
        
        if (replaceStr.isVisibleString && replaceStr.length > 1) {
            if (!_callWordTableView) {
                _callWordTableView = [[UITableView alloc] init];
                _callWordTableView.delegate = self;
                _callWordTableView.dataSource = self;
                CGPoint point= CGPointMake(kScreenWidth, textField.size.height);
                CGPoint convertPoint = [textField convertPoint:point toView:self.superview];
                
                _callWordTableView.frame = CGRectMake(kScreenWidth - 235, convertPoint.y, 220, 220);
                _callWordTableView.layer.shadowColor = HEX(0x999999).CGColor;
                
                _callWordTableView.layer.shadowRadius = 3;
                _callWordTableView.layer.shadowOpacity = 0.8;
                _callWordTableView.layer.shadowOffset = CGSizeMake(2, 2);
                [self.superview addSubview:_callWordTableView];
                _callWordTableView.clipsToBounds = NO;
                _callWordTableView.scrollEnabled = NO;
                _callWordTableView.showsVerticalScrollIndicator = NO;
                _callWordTableView.hidden = YES;
            }
            
//            _callWordTableView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fetchCallWords];
            });
        }
    }
    
    return YES;
}








- (void)fetchCallWords {
//    NSURLSessionTaskStateRunning = 0,                     /* The task is currently being serviced by the session */
//    NSURLSessionTaskStateSuspended = 1,
//    NSURLSessionTaskStateCanceling = 2,                   /* The task has been told to cancel.  The session will receive a URLSession:task:didCompleteWithError: message. */
//    NSURLSessionTaskStateCompleted = 3,
    if (_callWordTask.state != NSURLSessionTaskStateCompleted) {
        [_callWordTask cancel];
        _callWordTask = nil;
        
    }
//    NSString * secreteKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
    NSMutableDictionary * param = @{}.mutableCopy;
//    param[@"secretKey"] = secreteKey;
    param[@"title"] = _workPlaceField.text;
    param[@"start"] = @"0";
    param[@"limit"] = @"5";
    
    _callWordTask = [[WQNetworkTools sharedTools] request:WQHttpMethodPost urlString:@"/api/user/orgnamesuggestwork" parameters:param completion:^(id response, NSError *error) {
        NSLog(@"______________________\n_____________________\n%@",response);
        if (error) {
            return;
        }
        if ([response[@"success"] boolValue]) {
            
            NSArray *  results = response[@"results"];
            [_callWords removeAllObjects];
            for (NSDictionary * callWordInfo in results) {
                
                [_callWords addObject:callWordInfo[@"title"]];
            }
//            if (_callWordTableView.hidden) {
                _callWordTableView.hidden = !_callWords.count;
//            }
            if (_callWords.count) {
                [_callWordTableView reloadData];
            }
        }
    }];
    
    // MARK: 预留以防上面的方法不好用
    _callWordTask.taskDescription = _workPlaceField.text;
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.contentBlock) {
        self.contentBlock(textField.text);
    }
    
    if (textField == _workPlaceField) {
        _callWordTableView.hidden = YES;;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.gongsimingcheng endEditing:YES];
    [self.zhiweimingcheng endEditing:YES];
}
- (IBAction)kaishiBtnClike:(id)sender {
    [self.gongsimingcheng endEditing:YES];
    [self.zhiweimingcheng endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(wqkaishishijianBtnClikeDelegate:)]) {
        [self.delegate wqkaishishijianBtnClikeDelegate:self];
    }
}
- (IBAction)jiesuBtnClike:(id)sender {
    [self.gongsimingcheng endEditing:YES];
    [self.zhiweimingcheng endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(wqjieshushijianBtnClikeDelegate:)]) {
        [self.delegate wqjieshushijianBtnClikeDelegate:self];
    }
}


#pragma make - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [UITableViewCell new];
    if (indexPath.row < _callWords.count) {
        cell.textLabel.text = _callWords[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _workPlaceField.text = _callWords[indexPath.row];
    [tableView removeFromSuperview];
    tableView = nil;
}
@end
