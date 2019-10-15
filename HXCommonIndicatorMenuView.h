//
//  HXCommonIndicaMenuView.h
//  ParentDemo
//
//  Created by James on 2019/10/13.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <HXConvenientListView/HXConvenientListView.h>

#import "HXUnionScrollViewHead.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HXIndicatorMenuLayoutStyle) {
    HXIndicatorMenuLayoutStyle_CenterEqualDivide,//only works in menu's contensize < frame.width when this works config of custom interitemSpacing will be ignored
    HXIndicatorMenuLayoutStyle_MarginEqualDivide, //only works in menu's contensize < frame.width and when this works config of custom edge and interitemSpacing will be ignored
    HXIndicatorMenuLayoutStyle_AutoDivide,
};


@class HXCommonIndicatorMenuView;

@protocol HXCommonIndicatorMenuViewDataSoucre <NSObject>

- (NSInteger)menuItemsNumInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

- (NSString *)menuTitleInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView atIndex:(NSInteger)index;

@optional

//default 44
- (CGFloat)sliderWidthInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//defautl 2
- (CGFloat)sliderHeightInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 1
- (CGFloat)sliderCornerRadiusInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default SliderStyleNormal
- (SliderStyle)sliderStyleInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 0
- (CGFloat)sliderBottomMarginInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 15
- (CGFloat)edgeInsetLeftInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 15
- (CGFloat)edgeInsetRightInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 12
- (CGFloat)interitemSpacingInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default 1.0(no scale)
- (CGFloat)menuItemScaleFacorInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default black
- (UIColor *)normalColorInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default red
- (UIColor *)selectedColorInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default red
- (UIColor *)sliderColorInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default [UIFont systemFontOfSize:15];
- (UIFont *)menuTitleFontInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default HXIndicatorMenuLayoutStyle_CenterEqualDivide
- (HXIndicatorMenuLayoutStyle)layoutStyleInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;

//default @"HXIndicatorMemuItemView"
- (NSString *)customMenuItemViewClassStrInHXCommonIndicatorMenuView:(HXCommonIndicatorMenuView *)menuView;
@end


@interface HXCommonIndicatorMenuView : HXBaseConvenientView<HXUpDownUnionScrollViewMenuViewDelegate>
@property (nonatomic, weak) id<HXCommonIndicatorMenuViewDataSoucre>   menuDataSource;
@property (nonatomic, weak) id<HXIndicatorMenuViewDelegate> unionDelegate;

@property (nonatomic, readonly) NSInteger currentIndex;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
