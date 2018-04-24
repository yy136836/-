//
//  WQPhotoBrowser.m
//  WanQuan-iOS
//
//  Created by hanyang on 2017/6/5.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "WQPhotoBrowser.h"

@interface WQPhotoBrowser ()

@end

@implementation WQPhotoBrowser {
    UIPageControl * _control;
    UILabel *_numBerLB;
    UIButton *_saveBtn;
    int totla;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.shouldHideNavBar) {

        [self setControlsHidden:YES animated:NO permanent:YES];
    }
    
    
    if (_shouldSave) {
        _numBerLB = [[UILabel alloc]init];
        _numBerLB.textColor = [UIColor whiteColor];
        _numBerLB.font = [UIFont fontWithName:@".PingFangSC-Medium" size:14];
        [self.view addSubview:_numBerLB];
        _numBerLB.textAlignment = NSTextAlignmentCenter;
        _numBerLB.backgroundColor = UIColorWithHex16_Alpha(0x000000,0.25);
        [WQTool borderForView:_numBerLB color: nil borderWidth:0 borderRadius:10];
        
        [_numBerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(25);
            make.size.mas_equalTo(CGSizeMake(52,25));
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
        totla = (int)[self.delegate numberOfPhotosInPhotoBrowser:self];
        [self setLabeText];

        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:0];
        _saveBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:14];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self.view addSubview:_saveBtn];
        _saveBtn.backgroundColor = UIColorWithHex16_Alpha(0x000000,0.25);
        [_saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        [WQTool borderForView:_saveBtn color:nil borderWidth:0 borderRadius:10];

        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right).offset(-77);
            make.size.mas_equalTo(CGSizeMake(52, 25));
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
    }else{
        _control = [[UIPageControl alloc] init];
        _control.numberOfPages = [self.delegate numberOfPhotosInPhotoBrowser:self];
        _control.currentPage = self.currentIndex;
        [self.view addSubview:_control];
        [_control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            
        }];
    }
    
    self.zoomPhotosToFill = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)toggleControls {
    if (self.shouldTapBack) {
        if(self.navigationController.topViewController == self) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [super toggleControls];
    }
}

- (void)saveClicked
{
    if (![[WQAuthorityManager manger] haveAlbumAuthority]) {
        [[WQAuthorityManager manger] showAlertForAlbumAuthority];
        return;
    }
    [self savePhoto];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    _control.currentPage = self.currentIndex;
    [self performSelector:@selector(setLabeText) withObject:nil afterDelay:.5];

}

- (void)setLabeText{
    _numBerLB.text = [NSString stringWithFormat:@"%d/%d",(int)self.currentIndex+1,totla];

}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
