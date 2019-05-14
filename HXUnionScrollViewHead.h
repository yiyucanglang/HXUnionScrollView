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



#endif /* HXUnionScrollViewHead_h */
