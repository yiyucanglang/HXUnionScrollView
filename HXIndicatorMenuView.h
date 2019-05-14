//
//  HXIndicatorMenuView.h
//  JenkinsTest
//
//  Created by 周义进 on 2018/10/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXUnionScrollViewHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXIndicatorMenuView : UIView<HXUpDownUnionScrollViewMenuViewDelegate>
@property (nonatomic, assign) CGFloat     sliderWidth;

//default 2
@property (nonatomic, assign) CGFloat     sliderHeight;

@property (nonatomic, assign) BOOL        hiddenBottomLine;
@property (nonatomic, assign) CGFloat     sliderCornerRadius;

//default 2
@property (nonatomic, assign) CGFloat     sliderBottomMargin;

@property (nonatomic, assign) SliderStyle sliderStyle;
@property (nonatomic, weak) id<HXIndicatorMenuViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger currentIndex;

- (instancetype)initWithBtnTitleArray:(NSArray *)titleArray
                          sliderColor:(UIColor *)sliderColor
                       normalBtnColor:(UIColor *)normalBtnColor
                     selectedBtnColor:(UIColor *)selectedBtnColor
                              btnFont:(UIFont *)btnFont;

@end

NS_ASSUME_NONNULL_END
