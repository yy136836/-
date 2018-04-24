//
//  NSString+path.h
//  gh_load
//
//  Created by gh_load on 16/3/9.
//  Copyright © 2016年 gh_load. All rights reserved.
//  基本没用

#import <Foundation/Foundation.h>

@interface NSString (path)

/// 获取Documents目录
- (NSString *)appendDocumentsPath;
/// 获取Cache目录
- (NSString *)appendCachePath;
/// 获取Tmp目录
- (NSString *)appendTmpPath;

@end
