//
//  HTVGoldCoinLabel.h
//  GoldCoinLabelDemo
//
//  Created by boob on 2019/6/17.
//  Copyright © 2019年 boob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollGoldCoinNumLabel : UIView

@property (nonatomic, assign) IBInspectable NSInteger goldNum;

@property (nonatomic, strong) IBInspectable UIColor * textColor;

@property (nonatomic, strong) UIFont * font;

@property(nonatomic, assign) NSTextAlignment textAlignment;

@end

NS_ASSUME_NONNULL_END
