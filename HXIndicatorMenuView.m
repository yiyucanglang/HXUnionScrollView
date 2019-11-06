//
//  HXIndicatorMenuView.m
//  JenkinsTest
//
//  Created by 周义进 on 2018/10/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXIndicatorMenuView.h"

#define BtnOriginalTag   1000

@interface HXIndicatorMenuView()
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIColor        *normalColor;
@property (nonatomic, strong) UIColor        *selectColor;
@property (nonatomic, strong) UIColor        *sliderColor;
@property (nonatomic, strong) UIFont         *btnFont;
@property (nonatomic, strong) UIFont         *selectFont;//unused

@property (nonatomic, strong) UIView         *sliderView;
@property (nonatomic, strong) UIView         *bottomLine;

@property (nonatomic, assign) NSInteger      currentIndex;
@property (nonatomic, strong) NSMutableArray<MASConstraint *>  *btnBottomConstraintsArr;

@property (nonatomic, strong) NSMutableArray<MASConstraint *>  *btnTopConstraintsArr;

@end


@implementation HXIndicatorMenuView
#pragma mark - Life Cycle
- (instancetype)initWithBtnTitleArray:(NSArray *)titleArray sliderColor:(UIColor *)sliderColor normalBtnColor:(UIColor *)normalBtnColor selectedBtnColor:(UIColor *)selectedBtnColor btnFont:(UIFont *)btnFont {
    self = [super init];
    if (self)
    {
        NSAssert(titleArray.count, @"title数组不能为空");
        self.titleArray = [NSMutableArray arrayWithArray:titleArray];
        self.normalColor = normalBtnColor ?: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.selectColor = selectedBtnColor ?: [UIColor colorWithRed:104/255.0 green:189/255.0 blue:26/255.0 alpha:1];
        self.sliderColor = sliderColor ?: self.selectColor;
        self.btnFont = btnFont ?: [UIFont systemFontOfSize:15];
        self.sliderHeight = 2;
        self.sliderBottomMargin = 0;
        [self UILayout];
    }
    return self;
}

#pragma mark - System Method
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.sliderView.frame.size.width <= 0 && self.frame.size.width > 0)
    {
        
        UIButton *btn = (UIButton *)[self viewWithTag:_currentIndex + BtnOriginalTag];
        [btn setNeedsLayout];
        [btn layoutIfNeeded];
        CGRect  btnTitleFrame = [self convertRect:btn.titleLabel.frame fromView:btn];
        if (btnTitleFrame.size.width <= 0 ) {
            return;
        }
        if (self.sliderStyle == SliderStyleEqualMenuItem) {
            self.sliderWidth = btnTitleFrame.size.width;
        }
        self.sliderView.frame = CGRectMake(btnTitleFrame.origin.x - (self.sliderWidth - btnTitleFrame.size.width)/2, self.frame.size.height - self.sliderBottomMargin - self.sliderHeight, self.sliderWidth, self.sliderHeight);
        self.sliderView.layer.cornerRadius = self.sliderCornerRadius;
        if (!self.sliderView.superview) {
            [self addSubview:self.sliderView];
        }
    }
    
}

#pragma mark - Public Method
- (void)selectItem:(NSInteger)itemIndex  animated:(BOOL)animated {
    UIButton *btn = (UIButton *)[self viewWithTag:itemIndex + BtnOriginalTag];
    btn.selected = YES;
    [self updateUIWithSelectedBtn:btn animated:animated];
}

- (void)updateUIWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    UIButton *leftBtn  = (UIButton *)[self viewWithTag:leftIndex + BtnOriginalTag];
    CGRect  leftBtnTitleFrame = [self convertRect:leftBtn.titleLabel.frame fromView:leftBtn];
    
    UIButton *rightBtn = (UIButton *)[self viewWithTag:rightIndex + BtnOriginalTag];
    CGRect  rightBtnTitleFrame = [self convertRect:rightBtn.titleLabel.frame fromView:rightBtn];
    
    
    //处理颜色渐变
    if (leftBtn.selected) {
        
        UIColor *color = [HXIndicatorMenuView hx_middleColorWithFromColor:self.selectColor toColor:self.normalColor percent:ratio];
        [leftBtn setTitleColor:color forState:UIControlStateNormal];
        
    }else {
        UIColor *color = [HXIndicatorMenuView hx_middleColorWithFromColor:self.selectColor toColor:self.normalColor percent:ratio];
        [leftBtn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (rightBtn.selected) {
        
        UIColor *color = [HXIndicatorMenuView hx_middleColorWithFromColor:self.normalColor toColor:self.selectColor percent:ratio];
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
        
    }else {
        UIColor *color = [HXIndicatorMenuView hx_middleColorWithFromColor:self.normalColor toColor:self.selectColor percent:ratio];
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
    }
    
    //slider change
    CGFloat targetX = leftBtnTitleFrame.origin.x;
    CGFloat targetWidth = self.sliderWidth;
    
    if (ratio == 0) {
        targetX = leftBtnTitleFrame.origin.x + (leftBtnTitleFrame.size.width - targetWidth)/2.0;
    }else {
        CGFloat leftWidth = targetWidth;
        CGFloat rightWidth = targetWidth;
        
        CGFloat leftX = leftBtnTitleFrame.origin.x + (leftBtnTitleFrame.size.width - leftWidth)/2;
        CGFloat rightX = rightBtnTitleFrame.origin.x + (rightBtnTitleFrame.size.width - rightWidth)/2;
        
        if (self.sliderStyle == SliderStyleNormal) {
            targetX = [HXIndicatorMenuView interpolationFrom:leftX to:rightX percent:ratio];
        }
        else if (self.sliderStyle == SliderStyleEqualMenuItem) {
            
            //fix sliderView wrong position because of swipe very quickly
            if (ratio >= 0.91) {
                ratio = 1;
            }
            else if(ratio <= 0.09) {
                ratio = 0;
            }
            
            targetWidth = [HXIndicatorMenuView interpolationFrom:leftBtnTitleFrame.size.width to:rightBtnTitleFrame.size.width percent:ratio];
            targetX = [HXIndicatorMenuView interpolationFrom:leftBtnTitleFrame.origin.x to:rightBtnTitleFrame.origin.x percent:ratio];
        }
        else  {
            CGFloat maxWidth = rightX - leftX + rightWidth;
            //前50%，只增加width；后50%，移动x并减小width
            if (ratio <= 0.5) {
                targetX     = leftX;
                targetWidth = [HXIndicatorMenuView interpolationFrom:leftWidth to:maxWidth percent:ratio*2];
            }else {
                
                targetX = [HXIndicatorMenuView interpolationFrom:leftX to:rightX percent:(ratio - 0.5)*2];
                targetWidth = [HXIndicatorMenuView interpolationFrom:maxWidth to:rightWidth percent:(ratio - 0.5)*2];
            }
        }
    }
    CGRect frame = self.sliderView.frame;
    frame.origin.x = targetX;
    frame.size.width = targetWidth;
    self.sliderView.frame = frame;
}

#pragma mark - Private Method
- (void)UILayout {
    self.backgroundColor = [UIColor whiteColor];
    UIButton *lastBtn;
    for (NSInteger i = 0; i < self.titleArray.count; i++)
    {
        __block MASConstraint *btnBottomConstraint;
        __block MASConstraint  *btnTopConstraint;
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        btn.tag = BtnOriginalTag+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            
            btn.selected = YES;
            self.currentIndex = i;
            [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                btnTopConstraint = make.top.equalTo(self).with.offset(0);
                btnBottomConstraint = make.bottom.equalTo(self).with.offset(0);
                if (self.titleArray.count == 1) {
                    make.right.equalTo(self);
                }
            }];
        }
        else if(i == self.titleArray.count - 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.mas_right);
                make.right.equalTo(self);
                btnTopConstraint = make.top.equalTo(self).with.offset(0);
                btnBottomConstraint = make.bottom.equalTo(self).with.offset(0);
                make.size.equalTo(lastBtn);
            }];
        }
        else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                btnTopConstraint = make.top.equalTo(self).with.offset(0);
                btnBottomConstraint = make.bottom.equalTo(self).with.offset(0);
                make.left.equalTo(lastBtn.mas_right);
                make.size.equalTo(lastBtn);
            }];
        }
        
        [self.btnBottomConstraintsArr addObject:btnBottomConstraint];
        [self.btnTopConstraintsArr addObject:btnTopConstraint];
        
        btn.titleLabel.font = self.btnFont;
        lastBtn = btn;
        
        [btn setNeedsLayout];
        [btn layoutIfNeeded];
    }
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)btnClick:(UIButton *)sender {
    sender.selected = YES;
    [self updateUIWithSelectedBtn:sender animated:YES];
}

- (void)updateUIWithSelectedBtn:(UIButton *)sender animated:(BOOL)animated {
    CGRect btnTitleFrame = CGRectZero;
    for (int i = 0; i < self.titleArray.count; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i + BtnOriginalTag];
        if ([btn isEqual:sender])
        {
            self.currentIndex = i;
            [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
            btn.selected = YES;
            btnTitleFrame = [self convertRect:btn.titleLabel.frame fromView:btn];
        }
        else
        {
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
            btn.selected = NO;
        }
    }
    
    CGFloat duration = animated ? 0.35 : 0.0;
    [UIView animateWithDuration:duration animations:
     ^{
         CGRect targetFrame = self.sliderView.frame;
         if (self.sliderStyle == SliderStyleEqualMenuItem) {
             targetFrame.size.width = btnTitleFrame.size.width;
             self.sliderWidth = targetFrame.size.width;
         }
         
         targetFrame.origin.x = btnTitleFrame.origin.x - (self.sliderWidth - btnTitleFrame.size.width)/2;
         self.sliderView.frame = targetFrame;
         
     }];
    
    if ([self.delegate respondsToSelector:@selector(indicatorMenuView:didSelectedIndex:animated:)]) {
        [self.delegate indicatorMenuView:self didSelectedIndex:sender.tag - BtnOriginalTag animated:animated];
    }
}

#pragma mark class method
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)hx_middleColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    }
    return _bottomLine;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = self.sliderColor;
    }
    return _sliderView;
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine {
    self.bottomLine.hidden = hiddenBottomLine;
}

- (NSMutableArray<MASConstraint *> *)btnBottomConstraintsArr {
    if (!_btnBottomConstraintsArr) {
        _btnBottomConstraintsArr = [NSMutableArray array];
    }
    return _btnBottomConstraintsArr;
}

- (NSMutableArray<MASConstraint *> *)btnTopConstraintsArr {
    if (!_btnTopConstraintsArr) {
        _btnTopConstraintsArr = [NSMutableArray array];
    }
    return _btnTopConstraintsArr;
}

- (void)setMenuItemBottomMargin:(CGFloat)menuItemBottomMargin {
    for (MASConstraint *constraint in self.btnBottomConstraintsArr) {
        [constraint setOffset:-menuItemBottomMargin];
    }
}

- (void)setMenuItemTopMargin:(CGFloat)menuItemTopMargin {
    for (MASConstraint *constraint in self.btnTopConstraintsArr) {
        [constraint setOffset:menuItemTopMargin];
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    self.bottomLine.backgroundColor = lineColor;
}

#pragma mark - Dealloc

@end
