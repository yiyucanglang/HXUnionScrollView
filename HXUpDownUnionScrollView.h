//
//  HXInOutUnionScrollView.h
//  JenkinsTest
//
//  Created by 周义进 on 2018/10/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXUnionScrollViewHead.h"

@class HXUpDownUnionScrollView;
@protocol   HXUpDownUnionScrollViewDataSource;
@protocol   HXUpDownUnionScrollViewDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 @warning 禁止设置 HXUpDownUnionScrollView的datasource及delegate
 */
@interface HXUpDownUnionScrollView : UITableView
@property (nonatomic, weak) id<HXUpDownUnionScrollViewDataSource> hxdataSource;
@property (nonatomic, weak) id<HXUpDownUnionScrollViewDelegate> hxdelegate;

//默认值为当前系统导航栏左滑返回手势，此手势优先级高于控件滑动手势
@property (nonatomic, weak) UIGestureRecognizer *outerHighPriorityGestureRecognizer;

- (instancetype)initWithHXDataSource:(id<HXUpDownUnionScrollViewDataSource>)hxdataSource
                          hxDelegate:(id<HXUpDownUnionScrollViewDelegate>)hxdelegate
            associatedViewController:(UIViewController *)associatedViewController;

/**
 *  手动控制滚动到某个视图
 */
- (void)scrollToIndex:(NSInteger)pageIndex
             animated:(BOOL)animated;

- (void)allowHorizaontalScrollEnabled:(BOOL)scrollEnabled;

- (void)menuScrollToTop:(BOOL)animated;
@end


@protocol   HXUpDownUnionScrollViewDataSource<NSObject>

- (NSInteger)numberOfViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

#pragma mark containerView、ScrollView
- (UIViewController *)viewControllerInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView viewAtIndex:(NSInteger)index;

- (UIScrollView *)coreScrollViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView viewAtIndex:(NSInteger)index;

#pragma mark headView
- (UIView *)headViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (CGFloat)menuHeightInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


@optional
//默认0
- (CGFloat)customHoverTopMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;
/**
 系统方法（系统默认返回yes）该方法详细知识自行查阅文档

 @return  yes HXUpDownUnionScrollView接管子vc AppearanceMethods方法调用 no 遵循系统默认
 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;

#pragma mark customSuspensionView
- (UIView<HXUpDownUnionScrollViewMenuViewDelegate> *)customMenuViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


#pragma mark defaultSuspensionView

/**
 return suspensionView's titles
 @param upDownUnionScrollView upDownUnionScrollView
 @warning if use default suspensionView this method must implementation
 @return titles
 */
- (NSArray<NSString *> *)pageTitlesInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default [UIColor grayColor]
- (UIColor *)normalMenuColorInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default [UIColor redColor]
- (UIColor *)selectedMenuColorInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (UIColor *)sliderColorInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


//default [UIFont systemFontOfSize:15]
- (UIFont *)menuFontInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default 44
- (CGFloat)sliderWidthInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default 2
- (CGFloat)sliderHeightMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default 2
- (CGFloat)sliderBottomMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


- (CGFloat)sliderCornerRadiusInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (SliderStyle)sliderStyleInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (BOOL)menuBottomLineHiddenUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;
@end

@protocol   HXUpDownUnionScrollViewDelegate<NSObject>
@optional
- (void)upDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView didSelectItemAtIndex:(NSInteger)selectedIndex deselectItemAtIndex:(NSInteger)deselectIndex;

- (void)upDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView contentOffsetY:(CGFloat)contentOffsetY allowMaximumContentOffsetY:(CGFloat)allowMaximumContentOffsetY;
@end

NS_ASSUME_NONNULL_END
