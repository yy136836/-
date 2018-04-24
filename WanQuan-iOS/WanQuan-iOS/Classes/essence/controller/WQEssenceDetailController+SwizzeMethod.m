//
//  WQEssenceDetailController+SwizzeMethod.m
//  WanQuan-iOS
//
//  Created by Shmily on 2018/4/16.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQEssenceDetailController+SwizzeMethod.h"

static NSString *const kTouchJavaScriptString =
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

static NSString *const kImageJS               = @"keyForImageJS";
static NSString *const kImage                 = @"keyForImage";
static NSString *const kImageQRString         = @"keyForQR";

static const NSTimeInterval KLongGestureInterval = 0.8f;

@implementation WQEssenceDetailController (SwizzeMethod)

+(void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookWebView];
    });
}

+ (void)hookWebView
{
    SwizzlingMethod([self class], @selector(webViewDidStartLoad:), @selector(sl_webViewDidStartLoad:));
    SwizzlingMethod([self class], @selector(webView:shouldStartLoadWithRequest:navigationType:), @selector(sl_webView:shouldStartLoadWithRequest:navigationType:));
    SwizzlingMethod([self class], @selector(webViewDidFinishLoad:), @selector(sl_webViewDidFinishLoad:));
}

#pragma mark - seter and getter

- (void)setImageJS:(NSString *)imageJS
{
    objc_setAssociatedObject(self, &kImageJS, imageJS, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageJS
{
    return objc_getAssociatedObject(self, &kImageJS);
}

- (void)setQrCodeString:(NSString *)qrCodeString
{
    objc_setAssociatedObject(self, &kImageQRString, qrCodeString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)qrCodeString
{
    return objc_getAssociatedObject(self, &kImageQRString);
}

- (void)setImage:(UIImage *)image
{
    objc_setAssociatedObject(self, &kImage, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)image
{
    return objc_getAssociatedObject(self, &kImage);
}


#pragma mark - swizing

- (BOOL)sl_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"]) {
            
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"]) {
                
                NSLog(@"touch start!");
                
                float pointX = [[components objectAtIndex:3] floatValue];
                float pointY = [[components objectAtIndex:4] floatValue];
                
                NSLog(@"touch point (%f, %f)", pointX, pointY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pointX, pointY];
                
                NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
                
                self.imageJS = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    
                    self.imageJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pointX, pointY];
                    
                }
                
            } else {
                
                if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"]) {
                    NSLog(@"you are move");
                } else {
                    if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"end"]) {
                        NSLog(@"touch end");
                    }
                }
            }
        }
        
        if (self.imageJS) {
            NSLog(@"touching image");
        }
        
        return NO;
    }
    
    return [self sl_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)sl_webViewDidStartLoad:(UIWebView *)webView
{
    //Add long press gresture for web view
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = KLongGestureInterval;
    longPress.allowableMovement = 20;
    longPress.delegate = self;
    [self.webView addGestureRecognizer:longPress];
    
    [self sl_webViewDidStartLoad:webView];
}

- (void)sl_webViewDidFinishLoad:(UIWebView *)webView
{
    //cache manager
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    //inject js
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    [self sl_webViewDidFinishLoad:webView];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    if ([self isTouchingImage]) {
        if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            otherGestureRecognizer.enabled = NO;
            otherGestureRecognizer.enabled = YES;
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark - private Method
- (BOOL)isTouchingImage
{
    if (self.imageJS) {
        return YES;
    }
    return NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
        NSString *imageUrl = [self.webView stringByEvaluatingJavaScriptFromString:self.imageJS];
        if (imageUrl) {
            WQActionSheet *sheet = [[WQActionSheet alloc]initWithTitles:@[@"保存图片",@"取消"]];
            sheet.delegate = self;
            sheet.saveImage = imageUrl;
            [sheet show];
        }
}

-(void)clickedButton:(WQActionSheet *)sheetView ClickedName:(NSString *)name{
    if ([name isEqualToString:@"保存图片"]) {
        
        if (![[WQAuthorityManager manger] haveAlbumAuthority]) {
            [[WQAuthorityManager manger] showAlertForAlbumAuthority];
            return;
        }        
        [[WQNetworkTools sharedTools] saveImageToDiskWithUrl:sheetView.saveImage];
    }
}

@end
