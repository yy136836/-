//
//  ImagePicker.m
//  郭杭
//
//  Created by Liu Jinyong on 16/1/20.
//  Copyright © 2016年 郭杭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDImagePicker.h"

@interface BDImagePicker()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) BDImagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;

@end


static BDImagePicker *bdImagePickerInstance = nil;

@implementation BDImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(BDImagePickerFinishAction)finishAction {
    if (bdImagePickerInstance == nil) {
        bdImagePickerInstance = [[BDImagePicker alloc] init];
    }
    
    [bdImagePickerInstance showImagePickerFromViewController:viewController
                                               allowsEditing:allowsEditing
                                                finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(BDImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    UIActionSheet *sheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"拍照", @"从相册选择", nil];
        //_allowsEditing = YES;
    }else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"拍照",@"从相册选择", nil];
        //_allowsEditing = YES;
    }

    UIView *window = [UIApplication sharedApplication].keyWindow;
    [sheet showInView:viewController.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"拍照"]) {
            [[WQAuthorityManager manger] showAlertForCameraAuthority];
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = _allowsEditing;
            [_viewController presentViewController:picker animated:YES completion:nil];
    
        }else if ([title isEqualToString:@"从相册选择"]) {
            
            [[WQAuthorityManager manger] showAlertForAlbumAuthority];
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = _allowsEditing;
            [_viewController presentViewController:picker animated:YES completion:nil];
        }else {
            bdImagePickerInstance = nil;
        }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = _allowsEditing;
        [_viewController presentViewController:picker animated:YES completion:nil];
        
    }else if ([title isEqualToString:@"从相册选择"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = _allowsEditing;
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else {
        bdImagePickerInstance = nil;
    }*/
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        
        if (_finishAction) {
            _finishAction(image);
        }
        bdImagePickerInstance = nil;
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_finishAction) {
            _finishAction(nil);
        }
        bdImagePickerInstance = nil;
    }];
    
}

@end
