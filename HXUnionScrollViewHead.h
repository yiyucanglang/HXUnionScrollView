//
//  HXUnionScrollViewHead.h
//  ShengXue
//
//  Created by 周义进 on 2018/11/7.
//  Copyright © 2018 Sea. All rights reserved.
//

#ifndef HXUnionScrollViewHead_h
#define HXUnionScrollViewHead_h

#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, SliderStyle) {
    SliderStyleNormal,
    SliderStyleFlex
};

typedef NS_ENUM(NSInteger, UnionScrollViewSwipeDirection) {
    UnionScrollViewSwipeDirection_Left,
    UnionScrollViewSwipeDirection_Right
};

@protocol HXIndicatorMenuViewDelegate;
@protocol HXUpDownUnionScrollViewMenuViewDelegate <NSObject>

@property (nonatomic, weak) id<HXIndicatorMenuViewDelegate> unionDelegate;

@optional
@property (nonatomic, weak) id<HXIndicatorMenuViewDelegate> delegate; __deprecated;

- (void)selectItem:(NSInteger)itemIndex
          animated:(BOOL)animated;

- (void)updateUIWithLeftIndex:(NSInteger)leftIndex
                   rightIndex:(NSInteger)rightIndex
                        ratio:(CGFloat)ratio;

@end


@protocol HXIndicatorMenuViewDelegate<NSObject>
- (void)indicatorMenuView:(UIView<HXUpDownUnionScrollViewMenuViewDelegate> *)indicatorMenuView didSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end


@protocol HXCommonIndicatorMenuItemViewDeleagte <NSObject>

- (void)updateColor:(UIColor *)color scale:(CGFloat)scale;

@end



#endif /* HXUnionScrollViewHead_h */
