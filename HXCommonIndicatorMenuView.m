//
//  HXCommonIndicaMenuView.m
//  ParentDemo
//
//  Created by James on 2019/10/13.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXCommonIndicatorMenuView.h"
#import <HXConvenientListView/HXConvenientListView.h>

#import "HXCommonIndicatorMenuItemModel.h"
#import "HXIndicatorMemuItemView.h"

@interface HXCommonIndicatorMenuView()
<
    UIScrollViewDelegate
>

@property (nonatomic, assign) CGFloat     sliderWidth;

//default 2
@property (nonatomic, assign) CGFloat     sliderHeight;

@property (nonatomic, assign) CGFloat     sliderCornerRadius;

//default 2
@property (nonatomic, assign) CGFloat     sliderBottomMargin;

@property (nonatomic, assign) SliderStyle sliderStyle;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIColor        *normalColor;
@property (nonatomic, strong) UIColor        *selectColor;
@property (nonatomic, strong) UIColor        *sliderColor;
@property (nonatomic, strong) UIFont         *btnFont;

@property (nonatomic, assign) CGFloat   edgeInsetRight;
@property (nonatomic, assign) CGFloat   menuItemScaleFacor;
@property (nonatomic, assign) CGFloat   edgeInsetLeft;
@property (nonatomic, assign) CGFloat   interitemSpacing;
@property (nonatomic, assign) CGFloat   mininumMenuItemWidth;

@property (nonatomic, assign) HXIndicatorMenuLayoutStyle     layoutStyle;
@property (nonatomic, copy) NSString  *customMenuItemViewClassStr;

@property (nonatomic, strong) NSMutableArray<HXCommonIndicatorMenuItemModel *> *menuItemsArr;

@property (nonatomic, strong) HXConvenientCollectionView  *collectionView;
@property (nonatomic, strong) UIView         *sliderView;

@property (nonatomic, assign) NSInteger      currentIndex;
@end

@implementation HXCommonIndicatorMenuView
#pragma mark - Life Cycle
- (void)UIConfig {
    [super UIConfig];
    self.tap.enabled = NO;
    [self addSubview:self.collectionView];
    
    [self.collectionView addSubview:self.sliderView];
    
}

#pragma mark - System Method



#pragma mark - Public Method
- (void)reload {
    [self _setupDefaultConfig];
    if ([self.menuDataSource respondsToSelector:@selector(menuTitleFontInHXCommonIndicatorMenuView:)]) {
        self.btnFont = [self.menuDataSource menuTitleFontInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(normalColorInHXCommonIndicatorMenuView:)]) {
        self.normalColor = [self.menuDataSource normalColorInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(selectedColorInHXCommonIndicatorMenuView:)]) {
        self.selectColor = [self.menuDataSource selectedColorInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderColorInHXCommonIndicatorMenuView:)]) {
        self.sliderColor = [self.menuDataSource sliderColorInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderStyleInHXCommonIndicatorMenuView:)]) {
        self.sliderStyle = [self.menuDataSource sliderStyleInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderWidthInHXCommonIndicatorMenuView:)]) {
        self.sliderWidth = [self.menuDataSource sliderWidthInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderHeightInHXCommonIndicatorMenuView:)]) {
        self.sliderHeight = [self.menuDataSource sliderHeightInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderCornerRadiusInHXCommonIndicatorMenuView:)]) {
        self.sliderCornerRadius = [self.menuDataSource sliderCornerRadiusInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(sliderBottomMarginInHXCommonIndicatorMenuView:)]) {
        self.sliderBottomMargin = [self.menuDataSource sliderBottomMarginInHXCommonIndicatorMenuView:self];
    }
    
    if ([self.menuDataSource respondsToSelector:@selector(menuItemScaleFacorInHXCommonIndicatorMenuView:)]) {
        self.menuItemScaleFacor = [self.menuDataSource menuItemScaleFacorInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(menuItemScaleFacorInHXCommonIndicatorMenuView:)]) {
        self.menuItemScaleFacor = [self.menuDataSource menuItemScaleFacorInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(edgeInsetLeftInHXCommonIndicatorMenuView:)]) {
        self.edgeInsetLeft = [self.menuDataSource edgeInsetLeftInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(edgeInsetRightInHXCommonIndicatorMenuView:)]) {
        self.edgeInsetRight = [self.menuDataSource edgeInsetRightInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(interitemSpacingInHXCommonIndicatorMenuView:)]) {
        self.edgeInsetRight = [self.menuDataSource interitemSpacingInHXCommonIndicatorMenuView:self];
    }
    
    if ([self.menuDataSource respondsToSelector:@selector(layoutStyleInHXCommonIndicatorMenuView:)]) {
        self.layoutStyle = [self.menuDataSource layoutStyleInHXCommonIndicatorMenuView:self];
    }
    if ([self.menuDataSource respondsToSelector:@selector(customMenuItemViewClassStrInHXCommonIndicatorMenuView:)]) {
        self.customMenuItemViewClassStr = [self.menuDataSource customMenuItemViewClassStrInHXCommonIndicatorMenuView:self];
    }
    
    if ([self.menuDataSource respondsToSelector:@selector(mininumMenuItemWidthInHXCommonIndicatorMenuView:)]) {
        self.mininumMenuItemWidth = [self.menuDataSource mininumMenuItemWidthInHXCommonIndicatorMenuView:self];
    }
    
    self.menuItemsArr = [NSMutableArray array];
    UILabel *tempLB = [[UILabel alloc] init];
    tempLB.font = self.btnFont;
    for (NSInteger i = 0; i < [self.menuDataSource menuItemsNumInHXCommonIndicatorMenuView:self]; i++) {
        NSString *title =  [self.menuDataSource menuTitleInHXCommonIndicatorMenuView:self atIndex:i];
        
        [self.titleArray addObject:title];
        
        HXCommonIndicatorMenuItemModel *model = [HXCommonIndicatorMenuItemModel model];
        if (i == 0) {
            model.selected = YES;
        }
        model.viewClassName = self.customMenuItemViewClassStr;
        model.scale = self.menuItemScaleFacor;
        model.viewHeight = self.frame.size.height;
        model.mininumWidth = self.mininumMenuItemWidth;
        model.delegate = (id<HXConvenientViewDelegate>)self;
        model.title = title;
        model.btnFont = self.btnFont;
        model.normalColor = self.normalColor;
        model.selectColor = self.selectColor;
        [model autoCalculateWidth];
        [self.menuItemsArr addObject:model];
    }
    
    if (self.layoutStyle != HXIndicatorMenuLayoutStyle_AutoDivide) {
        
        CGFloat contentSizeWidth =  self.edgeInsetLeft;
        CGFloat menuItemsWholeWidth =  0;
        for (NSInteger i = 0; i < self.menuItemsArr.count; i++) {
            contentSizeWidth += self.menuItemsArr[i].viewWidth;
            contentSizeWidth += self.interitemSpacing;
            
            menuItemsWholeWidth += self.menuItemsArr[i].viewWidth;
            
        }
        contentSizeWidth += self.edgeInsetRight;
        
        
        if (contentSizeWidth < self.frame.size.width) {
            
            if (self.layoutStyle == HXIndicatorMenuLayoutStyle_CenterEqualDivide) {
                self.interitemSpacing = 0;
                CGFloat menuItemWidth = floor((self.frame.size.width - self.edgeInsetLeft - self.edgeInsetRight)/self.menuItemsArr.count);
                for (HXCommonIndicatorMenuItemModel *item in self.menuItemsArr) {
                    item.viewWidth = menuItemWidth;
                }
            }
            else {
                CGFloat sapcing = floor(self.frame.size.width - menuItemsWholeWidth)/(self.menuItemsArr.count + 1);
                self.edgeInsetLeft = sapcing;
                self.edgeInsetRight = sapcing;
                self.interitemSpacing = sapcing;
            }
            
            
        }
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing      = self.interitemSpacing;
    layout.minimumInteritemSpacing = self.interitemSpacing;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, self.edgeInsetLeft, 0, self.edgeInsetRight);
    
    [self.collectionView.sourceArr addObjectsFromArray:self.menuItemsArr];
    [self.collectionView reloadData];
    
    
    self.sliderView.backgroundColor = self.sliderColor;
    
    if (self.sliderStyle == SliderStyleEqualMenuItem) {
        self.sliderWidth = self.menuItemsArr[0].viewWidth;
    }
    
    self.sliderView.frame = CGRectMake(0, self.frame.size.height - self.sliderHeight - self.sliderBottomMargin, self.sliderWidth, self.sliderHeight);
    self.sliderView.layer.cornerRadius = self.sliderCornerRadius;
    
    [self _moveSliderToAvailablePosition];
}

- (void)selectItem:(NSInteger)itemIndex animated:(BOOL)animated {
    
    if (itemIndex == self.currentIndex) {
        return;
    }
    
    HXCommonIndicatorMenuItemModel *oldModel = self.menuItemsArr[self.currentIndex];
    oldModel.selected = NO;
    
    self.currentIndex = itemIndex;
    HXCommonIndicatorMenuItemModel *newModel = self.menuItemsArr[self.currentIndex];
    newModel.selected = YES;
    
    [self.collectionView reloadData];
    CGFloat duration = animated ? 0.35 : 0.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [newModel.collectionView scrollToItemAtIndexPath:newModel.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    });
    
    
    [UIView animateWithDuration:duration animations:
     ^{
         [self _moveSliderToAvailablePosition];
     }];
    
    if ([self.unionDelegate respondsToSelector:@selector(indicatorMenuView:didSelectedIndex:animated:)]) {
        [self.unionDelegate indicatorMenuView:self didSelectedIndex:itemIndex animated:animated];
    }
}

- (void)updateUIWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    HXCommonIndicatorMenuItemModel *leftModel  = self.menuItemsArr[leftIndex];
    HXCommonIndicatorMenuItemModel *rightModel = self.menuItemsArr[rightIndex];
    
    UIView<HXCommonIndicatorMenuItemViewDeleagte> *leftItemView = leftModel.associatedItemView;
    UIView<HXCommonIndicatorMenuItemViewDeleagte> *rightItemView = rightModel.associatedItemView;
    
    UICollectionViewCell *leftCell  = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:leftIndex inSection:0]];
    CGRect  leftBtnTitleFrame;
    if (!leftCell) {
        CGFloat targetCellOriginX = 0;
        CGFloat targetCellWidth = self.menuItemsArr[leftIndex].viewWidth;
        
        for (NSInteger i = 0; i < leftIndex; i++) {
            targetCellOriginX += self.menuItemsArr[i].viewWidth;
            targetCellOriginX += self.interitemSpacing;
        }
        leftBtnTitleFrame = CGRectMake(targetCellOriginX, 0, targetCellWidth, 0);
    }
    else {
        leftBtnTitleFrame = leftCell.frame;
    }

    UICollectionViewCell *rightCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:rightIndex inSection:0]];
    CGRect  rightBtnTitleFrame;
    if (!rightCell) {
        CGFloat targetCellOriginX = 0;
        CGFloat targetCellWidth = self.menuItemsArr[rightIndex].viewWidth;
        
        for (NSInteger i = 0; i < rightIndex; i++) {
            targetCellOriginX += self.menuItemsArr[i].viewWidth;
            targetCellOriginX += self.interitemSpacing;
        }
        rightBtnTitleFrame = CGRectMake(targetCellOriginX, 0, targetCellWidth, 0);
    }
    else {
        rightBtnTitleFrame = rightCell.frame;
    }
   
    
    //处理颜色渐变及大小变换
    if (leftModel.selected) {
        
        UIColor *color = [self hx_middleColorWithFromColor:self.selectColor toColor:self.normalColor percent:ratio];
        CGFloat scale = [self scaleInterpolationFrom:self.menuItemScaleFacor to:1 percent:ratio];
        
        [leftItemView updateColor:color scale:scale];
        
    }else {
        UIColor *color = [self hx_middleColorWithFromColor:self.selectColor toColor:self.normalColor percent:ratio];
        CGFloat scale = [self scaleInterpolationFrom:self.menuItemScaleFacor to:1 percent:ratio];
        [leftItemView updateColor:color scale:scale];
    }
    
    if (rightModel.selected) {
        
        UIColor *color = [self hx_middleColorWithFromColor:self.normalColor toColor:self.selectColor percent:ratio];
        CGFloat scale = [self scaleInterpolationFrom:1 to:self.menuItemScaleFacor percent:ratio];
        [rightItemView updateColor:color scale:scale];
        
    }else {
        UIColor *color = [self hx_middleColorWithFromColor:self.normalColor toColor:self.selectColor percent:ratio];
        CGFloat scale = [self scaleInterpolationFrom:1 to:self.menuItemScaleFacor percent:ratio];
        [rightItemView updateColor:color scale:scale];
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
            targetX = [self interpolationFrom:leftX to:rightX percent:ratio];
        }
        else if (self.sliderStyle == SliderStyleEqualMenuItem) {
            
            //fix sliderView wrong position because of swipe very quickly
            if (ratio >= 0.91) {
                ratio = 1;
            }
            else if(ratio <= 0.09) {
                ratio = 0;
            }
            targetWidth = [self interpolationFrom:leftBtnTitleFrame.size.width to:rightBtnTitleFrame.size.width percent:ratio];
            targetX = [self interpolationFrom:leftBtnTitleFrame.origin.x to:rightBtnTitleFrame.origin.x percent:ratio];
        }
        else  {
            CGFloat maxWidth = rightX - leftX + rightWidth;
            //前50%，只增加width；后50%，移动x并减小width
            if (ratio <= 0.5) {
                targetX     = leftX;
                targetWidth = [self interpolationFrom:leftWidth to:maxWidth percent:ratio*2];
            }else {

                targetX = [self interpolationFrom:leftX to:rightX percent:(ratio - 0.5)*2];
                targetWidth = [self interpolationFrom:maxWidth to:rightWidth percent:(ratio - 0.5)*2];
            }
        }
    }
    CGRect frame = self.sliderView.frame;
    frame.origin.x = targetX;
    frame.size.width = targetWidth;
    self.sliderView.frame = frame;
}

#pragma mark - Override

#pragma mark - Private Method
- (void)_setupDefaultConfig {
    self.titleArray = [NSMutableArray array];
    self.normalColor = [UIColor blackColor];
    self.selectColor = [UIColor redColor];
    self.sliderColor = self.selectColor;
    self.btnFont = [UIFont systemFontOfSize:15];
    self.sliderHeight = 2;
    self.sliderBottomMargin = 0;
    self.sliderWidth = 44;
    self.sliderCornerRadius = 1;
    self.menuItemScaleFacor = 1.0;
    self.edgeInsetLeft = 15;
    self.edgeInsetRight = 15;
    self.interitemSpacing = 12;
    self.mininumMenuItemWidth = 20;
    self.customMenuItemViewClassStr = @"HXIndicatorMemuItemView";
}

- (void)_moveSliderToAvailablePosition {
    CGFloat targetCellOriginX =  0;
    
    CGFloat targetCellWidth = self.menuItemsArr[self.currentIndex].viewWidth;
    
    for (NSInteger i = 0; i < self.currentIndex; i++) {
        targetCellOriginX += self.menuItemsArr[i].viewWidth;
        targetCellOriginX += self.interitemSpacing;
    }
    
    CGRect targetFrame = self.sliderView.frame;
    
    if (self.sliderStyle == SliderStyleEqualMenuItem) {
        self.sliderWidth = targetCellWidth;
        targetFrame.size.width = self.sliderWidth;
    }
    
    targetFrame.origin.x = targetCellOriginX- (self.sliderWidth - targetCellWidth)/2;
    self.sliderView.frame = targetFrame;
}

- (CGFloat)scaleInterpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(self.menuItemScaleFacor, percent));
    return from + (to - from)*percent;
}

- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

- (UIColor *)hx_middleColorWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
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
#pragma mark HXIndicatorMemuItemView
-(void)handleActionInHXIndicatorMemuItemViewWithModel:(HXBaseConvenientViewModel *)model view:(HXIndicatorMemuItemView *)view {
    NSInteger index = [self.menuItemsArr indexOfObject:(HXCommonIndicatorMenuItemModel *)model];
    [self selectItem:index animated:YES];
}

#pragma mark - Setter And Getter
- (HXConvenientCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 12;
        _collectionView = [[HXConvenientCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = (id<UICollectionViewDelegate>) self;
        _collectionView.dataSource = (id<UICollectionViewDataSource>) self;
    }
    return _collectionView;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
    }
    return _sliderView;
}


#pragma mark - Dealloc
@end
