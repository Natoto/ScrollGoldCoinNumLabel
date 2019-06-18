//
//  ViewController.m
//  GoldCoinLabelDemo
//
//  Created by boob on 2019/6/17.
//  Copyright © 2019年 boob. All rights reserved.
//

#import "ViewController.h"
#import "ScrollGoldCoinNumLabel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ScrollGoldCoinNumLabel *goldLabel;
@property (weak, nonatomic) IBOutlet ScrollGoldCoinNumLabel *label3;
@property (weak, nonatomic) IBOutlet ScrollGoldCoinNumLabel *label2;
@property (nonatomic, assign) NSInteger num2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    int num1 = arc4random()%10000;
    int num2 = arc4random()%10000;
    self.num2 = num2;
    self.goldLabel.font = [UIFont systemFontOfSize:18];
    self.goldLabel.textColor = [UIColor redColor];
    
    
    self.label2.goldNum = self.num2;
    self.label2.textAlignment = NSTextAlignmentCenter;
    
    
    self.label3.goldNum = self.num2;
    self.label3.textAlignment = NSTextAlignmentRight;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self.goldLabel updateText:@(num1) targetText:@(num2)];
    NSInteger num1 = arc4random()%100;
    self.num2 = self.num2 + num1;
    self.goldLabel.goldNum =self.num2;
    
    self.label2.goldNum = self.num2;
    
    self.label3.goldNum = self.num2;
    
}

@end
