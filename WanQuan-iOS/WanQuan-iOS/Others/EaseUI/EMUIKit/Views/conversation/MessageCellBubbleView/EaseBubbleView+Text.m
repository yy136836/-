/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseBubbleView+Text.h"

@implementation EaseBubbleView (Text)

#pragma mark - private

- (void)_setupTextBubbleMarginConstraints {
//    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:12];
//    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:12];
//    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:self.isSender?17:12];
//    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.isSender?12:17];
    
    [self.marginConstraints removeAllObjects];
//    [self.marginConstraints addObject:marginTopConstraint];
//    [self.marginConstraints addObject:marginBottomConstraint];
//    [self.marginConstraints addObject:marginLeftConstraint];
//    [self.marginConstraints addObject:marginRightConstraint];
//
    
    if (self.isSender) {
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.bottom.equalTo(@-12);
            make.right.equalTo(@-17);
            make.left.equalTo(@12);
        }];
    } else {
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.bottom.equalTo(@-12);
            make.right.equalTo(@-12);
            make.left.equalTo(@17);
            
        }];
    }
    
    
//    [self addConstraints:self.marginConstraints];
}

- (void)_setupTextBubbleConstraints
{
    [self _setupTextBubbleMarginConstraints];
}

#pragma mark - public 

- (void)setupTextBubbleView
{
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    [self.backgroundImageView addSubview:self.textLabel];
    
    [self _setupTextBubbleConstraints];
}

- (void)updateTextMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupTextBubbleMarginConstraints];
}

@end
