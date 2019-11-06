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

@property (nonatomic, assign, readonly) NSInteger           currentPageIndex;

@property (nonatomic, strong, readonly) UIView<HXUpDownUnionScrollViewMenuViewDelegate>  *menuView;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer  *horizontalCollectionViewGesture;

//默认值为当前系统导航栏左滑返回手势，此手势优先级高于控件滑动手势
@property (nonatomic, weak) UIGestureRecognizer *outerHighPriorityGestureRecognizer;

- (instancetype)initWithHXDataSource:(id<HXUpDownUnionScrollViewDataSource>)hxdataSource
                          hxDelegate:(id<HXUpDownUnionScrollViewDelegate>)hxdelegate
            associatedViewController:(UIViewController *)associatedViewController NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 *  手动控制滚动到某个视图
 */
- (void)scrollToIndex:(NSInteger)pageIndex
             animated:(BOOL)animated;

- (void)allowHorizaontalScrollEnabled:(BOOL)scrollEnabled;

- (void)menuScrollToTop:(BOOL)animated;

//this will let unionScrollView make to get the newest HeadView from dataSource method
- (void)reloadHeadView;
@end


@protocol   HXUpDownUnionScrollViewDataSource<NSObject>

- (NSInteger)numberOfViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (UIScrollView *)coreScrollViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView viewAtIndex:(NSInteger)index;

- (CGFloat)menuHeightInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


@optional

- (UIViewController * _Nullable)viewControllerInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView viewAtIndex:(NSInteger)index;

- (UIView * _Nullable)containerViewForScrollViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView viewAtIndex:(NSInteger)index;

#pragma mark headView
- (UIView *)headViewInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//默认0
- (CGFloat)customHoverTopMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;
/**
 系统方法（系统默认返回yes）该方法详细知识自行查阅文档

 @return  NO:HXUpDownUnionScrollView接管子vc AppearanceMethods方法调用; YES:遵循系统默认
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

//default 0
- (CGFloat)sliderBottomMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default 0
- (CGFloat)menuItemsTopMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default 0
- (CGFloat)menuItemsBottomMarginInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;


- (CGFloat)sliderCornerRadiusInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (SliderStyle)sliderStyleInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

- (BOOL)menuBottomLineHiddenUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;

//default [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]
- (UIColor *)menuBottomLineColorInUpDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView;
@end

@protocol   HXUpDownUnionScrollViewDelegate<NSObject>
@optional
- (void)upDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView didSelectItemAtIndex:(NSInteger)selectedIndex deselectItemAtIndex:(NSInteger)deselectIndex;

- (void)upDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView contentOffsetY:(CGFloat)contentOffsetY allowMaximumContentOffsetY:(CGFloat)allowMaximumContentOffsetY;

- (BOOL)upDownUnionScrollView:(HXUpDownUnionScrollView *)upDownUnionScrollView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
