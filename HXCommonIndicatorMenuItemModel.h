//
//  HXCommonIndicaMenuItemModel.h
//  ParentDemo
//
//  Created by James on 2019/10/13.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <HXConvenientListView/HXConvenientListView.h>

#import "HXUnionScrollViewHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCommonIndicatorMenuItemModel : HXBaseConvenientViewModel
@property (nonatomic, strong) UIColor        *normalColor;
@property (nonatomic, strong) UIColor        *selectColor;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, assign) BOOL   selected;
@property (nonatomic, strong) UIFont         *btnFont;
@property (nonatomic, assign) CGFloat         scale;

@property (nonatomic, weak) UIView<HXCommonIndicatorMenuItemViewDeleagte>   *associatedItemView;


- (void)autoCalculateWidth;
@end

NS_ASSUME_NONNULL_END
