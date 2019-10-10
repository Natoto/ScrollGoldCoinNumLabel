//
//  HTVGoldCoinLabel.m
//  GoldCoinLabelDemo
//
//  Created by boob on 2019/6/17.
//  Copyright © 2019年 boob. All rights reserved.
//

#import "ScrollGoldCoinNumLabel.h"

@implementation NSString(safe)

- (NSString *)safe_substringWithRange:(NSRange)range{
    
    if (self.length>=(range.location + range.length)) {
        return [self substringWithRange:range];
    }
    return @"";
}

@end

@interface HTVGoldCoinEntity : NSObject
@property (nonatomic, assign) float offset;
@property (nonatomic, assign) float tooffset;
@property (nonatomic, strong) NSString * fromChar;
@property (nonatomic, strong) NSString * toChar;
@property (nonatomic, strong) NSString * targetChar;
@property (nonatomic, assign) float containerHeight;
@property (nonatomic, assign) BOOL done;
@end

@implementation HTVGoldCoinEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        _toChar = @"";
        _fromChar = @"";
    }
    return self;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (NSString *)nextChar:(NSString *)fmchar
{
    if(![self isNum:self.targetChar]) return self.targetChar;
    
    if(!fmchar.length) return @"";
    
    
    NSString * _toChar = @"";
    long next = fmchar.integerValue;
    if(next == 9){
        _toChar = @"0";
    }else{
        _toChar = @(next+1).stringValue;
    }
    return _toChar;
}

-(void)reset{
    self.fromChar = self.targetChar;
    self.offset = self.containerHeight/2.0;
    self.tooffset = self.containerHeight/2.0;
    self.toChar = @"";
    self.done = YES;
}

- (BOOL)canscroll
{
    //都为空，直接赋值
    if(!self.targetChar.length ) return NO;
    
    
    if(!self.fromChar.length && self.targetChar.length ) return NO;
    
    //滚动到了中间位置
    if([self.toChar isEqualToString:self.targetChar] && (self.tooffset - self.containerHeight/2.0)<= 0){
        return NO;
    }
    
    //滚动到中间位置
    if([self.fromChar isEqualToString:self.targetChar] && (self.offset - self.containerHeight/2.0)<=0){
        return NO;
    }
    return YES;
}

@end

@interface ScrollGoldCoinNumLabel()

@property (nonatomic, assign) CGSize chatFontSize;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,HTVGoldCoinEntity *> * ylocationoffset;
@property (nonatomic, assign) float timerCount;
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * targetText;

@property (nonatomic, assign) CGSize labelSize;
@end

@implementation ScrollGoldCoinNumLabel
@synthesize font = _font;

-(void)setGoldNum:(NSInteger)goldNum{
    
    _goldNum = goldNum;
    [self updateText:@(self.targetText.intValue) targetText:@(goldNum)];
    
}


/**
 绘制入口
 
 @param rect rect
 */
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGSize size = [self chatFontSize];
    
    float x = 0;
    float totalsize = size.width * [self maxstrlength];
    float offset = 0.0;
    if(self.textAlignment == NSTextAlignmentLeft){
        offset = 0;
    }else if(self.textAlignment == NSTextAlignmentCenter) {
        offset = self.bounds.size.width/2.0 - totalsize/2.0;
    }
    else if(self.textAlignment == NSTextAlignmentRight){
        offset = self.bounds.size.width - totalsize;
    }
    
    for (int idx = 0; idx<[self maxstrlength]; idx++) {
        HTVGoldCoinEntity * en = [self.ylocationoffset objectForKey:@(idx)];
        [self drawTextWithChar:en.fromChar rect:CGRectMake(offset + x,en.offset - size.height/2.0 ,size.width,size.height)];
        [self drawTextWithChar:en.toChar rect:CGRectMake(offset + x,en.tooffset - size.height/2.0 ,size.width,size.height)];
        x+=size.width;
    }
    self.labelSize = CGSizeMake(x, size.height);
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib{
    
    [super awakeFromNib];
}

-(CGSize)chatFontSize{
    
    if (CGSizeEqualToSize(_chatFontSize, CGSizeZero)) {
        
        CGRect rect = [@"0" boundingRectWithSize:CGSizeMake(36, MAXFLOAT) options:0 attributes:@{NSFontAttributeName: self.font} context:nil];
        _chatFontSize = rect.size;
    }
    return _chatFontSize;
    
}

-(NSInteger)maxstrlength{
    if(self.text.length > self.targetText.length)
    return self.text.length;
    return self.targetText.length;
}
/**
 初始化配置
 */
- (void)updateText:(NSNumber *)text targetText:(NSNumber *)targetText
{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.ylocationoffset removeAllObjects];
    _text =  text.stringValue; // @"676767";
    _targetText = targetText.stringValue;  // @"15546484";
    for (int idx = 0; idx<self.maxstrlength; idx++) {
        HTVGoldCoinEntity * en = [HTVGoldCoinEntity new];
        en.offset = self.bounds.size.height/2.0;
        en.tooffset = self.bounds.size.height/2.0 + [self chatFontSize].height + 2;
        en.targetChar =[self.targetText safe_substringWithRange:NSMakeRange(idx, 1)];;
        en.containerHeight = self.bounds.size.height;
        en.fromChar = [self.text safe_substringWithRange:NSMakeRange(idx, 1)];
        en.toChar = [en nextChar:en.fromChar];
        [self.ylocationoffset setObject:en forKey:@(idx)];
    }
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)handleTimer:(NSTimer *)timer{
    
    //    NSLog(@"timerCount : %.2f",self.timerCount);
    int donecount = 0;
    for (int idx = 0; idx<self.maxstrlength; idx++) {
        donecount +=[self moveCharIndx:idx];
    }
    if (donecount == [self maxstrlength]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}


/**
 移动第几个字符

 @param idx 序号
 @return 是否全部完成移动
 */
- (BOOL)moveCharIndx:(NSInteger)idx
{
    BOOL done = NO;
    float step = 5+idx%5;
    HTVGoldCoinEntity * en = [self.ylocationoffset objectForKey:@(idx)];
    float y = en.offset;
    if(y <= 0){
        y = self.bounds.size.height;
        en.fromChar = [en nextChar:en.toChar];
    }else{
        y = y  - (idx + step);
    }
    en.offset = y;
    
    float y2 = en.tooffset;
    if(y2 <= 0){
        y2 = self.bounds.size.height;
        en.toChar = [en nextChar:en.fromChar];;
    }else{
        y2 = y2  - (idx + step);
    }
    en.tooffset = y2;
    if(![en canscroll]){
        [en reset];
        done = YES;
    }
    [self.ylocationoffset setObject:en forKey:@(idx)];
    [self setNeedsDisplay];
    return done;
}

-(void)drawTextWithChar:(NSString *)str rect:(CGRect)frame
{
    NSMutableDictionary * textDict = [NSMutableDictionary dictionary];
    //设置文字颜色
    textDict[NSForegroundColorAttributeName] = self.textColor;
    //设置文字大小
    textDict[NSFontAttributeName] = self.font;
    
    //    //设置空心文字的颜色和宽度
        textDict[NSStrokeWidthAttributeName] = @3;
    
        textDict[NSStrokeColorAttributeName] = self.textColor;
    
    
        //创建阴影对象
        NSShadow * shadow = [[NSShadow alloc]init];
        //颜色
        shadow.shadowColor = [UIColor grayColor];
        //偏移量
        shadow.shadowOffset = CGSizeMake(2, 2);
        //模糊半径
        shadow.shadowBlurRadius = 3;
        //加入属性
        textDict[NSShadowAttributeName] = shadow;
    
    
    [str drawInRect:frame withAttributes:textDict];
}


- (NSMutableDictionary *)ylocationoffset {
    if (!_ylocationoffset) {
        _ylocationoffset = [[NSMutableDictionary alloc] init];
    }
    return _ylocationoffset;
}


- (UIColor *)textColor {
    if (!_textColor) {
        _textColor =  [UIColor redColor];
    }
    return _textColor;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont fontWithName:@"Roboto" size:15];
        if(!_font) {
          _font = [UIFont systemFontOfSize:15];
        }
    }
    return _font;
}
-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    NSString * fontname = [self.font fontName];
    self.font = [UIFont fontWithName:fontname size:_fontSize];
}

-(void)setFont:(UIFont *)font{
    
    @synchronized (self) {
        _font = font;
        _chatFontSize = CGSizeZero;
        [self chatFontSize];
    }
}
@end
