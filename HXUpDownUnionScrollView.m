//
//  HXInOutUnionScrollView.m
//  JenkinsTest
//
//  Created by 周义进 on 2018/10/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXUpDownUnionScrollView.h"
#import "HXIndicatorMenuView.h"

#if 0

#define HXLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define HXLog(...)

#endif

static NSString *kViewControllerKey            = @"kViewControllerKey";
static NSString *kScrollViewKey                = @"kScrollViewKey";

static NSString *kPagingCellIdentifier            = @"kPagingCellIdentifier";
static NSInteger kCellTag = 9527;

static void *HXHoverPageViewContentOffsetContext = &HXHoverPageViewContentOffsetContext;
static void *HXUnionScrollViewContentOffsetContext = &HXUnionScrollViewContentOffsetContext;
static void *HXUpDownUnionScrollViewtFrameContext = &HXUpDownUnionScrollViewtFrameContext;

@interface HXUpDownUnionScrollView()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    HXIndicatorMenuViewDelegate
>

@property (nonatomic, assign) BOOL  addHeadFrameObserver;

@property (nonatomic, strong) UIView<HXUpDownUnionScrollViewMenuViewDelegate> *menuView;
@property (nonatomic, strong) UICollectionView   *horizontalCollectionView;
@property (nonatomic, assign) NSInteger           currentPageIndex;
@property (nonatomic, assign) NSInteger           quickSwipeBeginPageIndex;
@property (nonatomic, strong) NSMutableArray *scrollViewsArr;

@property (nonatomic, strong) NSMutableArray *viewDataSourceArr;

@property (nonatomic, weak) UIViewController *associatedVC;

@property (nonatomic, assign) CGFloat customHoverTopMargin;

@property (nonatomic, strong) UIView  *currentHeadView;

@property (nonatomic, assign) CGSize  originalSize;
@property (nonatomic, assign) CGRect  originalRect;
@property (nonatomic, assign) CGPoint superContentOffset;
@property (nonatomic, assign) CGPoint currentSubScrollViewContentOffset;
@property (nonatomic, assign) UIInterfaceOrientation originalOrientation;
@end
@implementation HXUpDownUnionScrollView
#pragma mark - Life Cycle
- (instancetype)initWithHXDataSource:(id<HXUpDownUnionScrollViewDataSource>)hxdataSource hxDelegate:(id<HXUpDownUnionScrollViewDelegate>)hxdelegate associatedViewController:(nonnull UIViewController *)associatedViewController {
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.quickSwipeBeginPageIndex       = -1;
        self.currentPageIndex               = 0;
        self.dataSource                     = self;
        self.delegate                       = self;
        
        self.hxdataSource = hxdataSource;
        self.hxdelegate   = hxdelegate;
        self.associatedVC = associatedViewController;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.customHoverTopMargin = 0;
        if ([self.hxdataSource respondsToSelector:@selector(customHoverTopMarginInUpDownUnionScrollView:)]) {
            self.customHoverTopMargin = MAX(0, [self.hxdataSource customHoverTopMarginInUpDownUnionScrollView:self]);
        }
        [self _storeViewData];
        [self addScrollViewsObserver];
        
        self.originalOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
    }
    return self;
}

#pragma mark - System Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self.hxdelegate respondsToSelector:@selector(upDownUnionScrollView:gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.hxdelegate upDownUnionScrollView:self gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] &&
        [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class])
    {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        // 判断是否垂直滚动
        BOOL isVerticalScroll = ABS(velocity.y) * 0.5 >= ABS(velocity.x);
        return  isVerticalScroll;
    }
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &HXHoverPageViewContentOffsetContext)
    {
        
        NSValue *oldvalue   = change[NSKeyValueChangeOldKey];
        NSValue *newvalue   = change[NSKeyValueChangeNewKey];
        CGFloat oldoffset_y = oldvalue.UIOffsetValue.vertical;
        CGFloat newoffset_y = newvalue.UIOffsetValue.vertical;
        
        if (oldoffset_y == newoffset_y) {
            return;
        }
        
        if (self.originalOrientation != [UIApplication sharedApplication].statusBarOrientation) {
            return;
        }
        
        
        UIScrollView *scrollView = object;
        if (self.contentOffset.y < self._criticlalOffset) {
            scrollView.contentOffset = CGPointZero;
        }else {
            self.contentOffset = CGPointMake(0, self._criticlalOffset);
        }
        
        UIScrollView *currentScrollView = self.scrollViewsArr[self.currentPageIndex];
        if (scrollView == currentScrollView) {
            self.currentSubScrollViewContentOffset = scrollView.contentOffset;
        }
        
    }
    else if ([keyPath isEqualToString:@"frame"]) {
        NSValue *oldvalue   = change[NSKeyValueChangeOldKey];
        NSValue *newvalue   = change[NSKeyValueChangeNewKey];
        CGRect oldRect = [oldvalue CGRectValue];
        CGRect newRect = [newvalue CGRectValue];
        if (oldRect.size.height != newRect.size.height) {
            [self reloadHeadView];
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        
        [self createHeaderView];
        if (self.outerHighPriorityGestureRecognizer) {
            [self.horizontalCollectionView.panGestureRecognizer requireGestureRecognizerToFail:self.outerHighPriorityGestureRecognizer];
        }
        else {
            UIGestureRecognizer *defautGesture = self.associatedVC.navigationController.interactivePopGestureRecognizer;
            self.outerHighPriorityGestureRecognizer = defautGesture;
            if (defautGesture) {
                [self.horizontalCollectionView.panGestureRecognizer requireGestureRecognizerToFail:defautGesture];
            }
            
        }
    }
}


- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    if (contentOffset.y <= self._criticlalOffset) {
        [self resetSubScrollViewsContentOffset];
    }
    
    [super setContentOffset:contentOffset animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //REMARK: fix display position error and changed  when back from landscpae viewcontroller
    if (!CGRectEqualToRect(self.originalRect, self.frame)) {
        
        [self setContentOffset:self.superContentOffset];
        
        UIScrollView *scrollView = self.scrollViewsArr[self.currentPageIndex];
        scrollView.contentOffset = self.currentSubScrollViewContentOffset;
        
        self.originalRect = self.frame;
        
        [self.horizontalCollectionView setContentOffset:CGPointMake(self.currentPageIndex * self.horizontalCollectionView.frame.size.width, self.horizontalCollectionView.contentOffset.y) animated:NO];
    }
    
    if (self.originalOrientation == [UIApplication sharedApplication].statusBarOrientation) {
        self.superContentOffset = self.contentOffset;
    }
    
}

#pragma mark - Public Method
- (void)scrollToIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    if (self.horizontalCollectionView.frame.size.width <= 0) {
        self.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.menuView selectItem:pageIndex animated:animated];
            self.hidden = NO;
        });
    }
    else {
        [self.menuView selectItem:pageIndex animated:animated];
    }
}

- (void)menuScrollToTop:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, self._criticlalOffset) animated:animated];
}

- (void)allowHorizaontalScrollEnabled:(BOOL)scrollEnabled {
    self.horizontalCollectionView.scrollEnabled = scrollEnabled;
}

#pragma mark - Private Method

- (void)createHeaderView {
    if (self.addHeadFrameObserver) {
        [self.currentHeadView removeObserver:self forKeyPath:@"frame"];
        self.addHeadFrameObserver = NO;
    }
    
    if([self.hxdataSource respondsToSelector:@selector(headViewInUpDownUnionScrollView:)]) {
        self.currentHeadView = [self.hxdataSource headViewInUpDownUnionScrollView:self];
        
        self.tableHeaderView = self.currentHeadView;
        
        [self.tableHeaderView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.addHeadFrameObserver = YES;
    }
}

- (void)_storeViewData {
    NSInteger num = [self.hxdataSource numberOfViewInUpDownUnionScrollView:self];
    for (NSInteger i = 0; i < num; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [self.viewDataSourceArr addObject:dic];
        if ([self.hxdataSource respondsToSelector:@selector(viewControllerInUpDownUnionScrollView:viewAtIndex:)]) {
            dic[kViewControllerKey] = [self.hxdataSource viewControllerInUpDownUnionScrollView:self viewAtIndex:i];
        }
        dic[kScrollViewKey] = [self.hxdataSource coreScrollViewInUpDownUnionScrollView:self viewAtIndex:i];
    }
}

- (void)addScrollViewsObserver {
    NSInteger num = [self.hxdataSource numberOfViewInUpDownUnionScrollView:self];
    for (NSInteger i = 0; i < num; i++) {
        UIScrollView *view = [self.hxdataSource coreScrollViewInUpDownUnionScrollView:self viewAtIndex:i];
        [view addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&HXHoverPageViewContentOffsetContext];
        [self.scrollViewsArr addObject:view];
    }
    
}

- (void)removeScrollViewsObserver {
    for (NSInteger i = 0; i < self.scrollViewsArr.count; i++) {
        UIScrollView *view = self.scrollViewsArr[i];
        [view removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    }
}

- (void)adjustContentViewOffset {
    if (self.contentOffset.y >= self._criticlalOffset) {
        return;
    }
    [self resetSubScrollViewsContentOffset];
}

- (CGFloat)_criticlalOffset {
    return self.tableHeaderView.frame.size.height - self.customHoverTopMargin;
}

- (void)reloadHeadView {
    [self createHeaderView];
    [self reloadData];
    [self resetSubScrollViewsContentOffset];
}

- (void)resetSubScrollViewsContentOffset {
    NSInteger num = [self.hxdataSource numberOfViewInUpDownUnionScrollView:self];
    for (NSInteger i = 0; i < num; i++) {
        UIScrollView *view = [self.hxdataSource coreScrollViewInUpDownUnionScrollView:self viewAtIndex:i];
        view.contentOffset = CGPointZero;
    }
}

- (void)collectionViewContentOffsetDidChanged:(CGPoint)contentOffset {
    
    CGFloat ratio = contentOffset.x/self.horizontalCollectionView.bounds.size.width;
    NSInteger num = [self.hxdataSource numberOfViewInUpDownUnionScrollView:self];
    ratio = MAX(0, MIN(num - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;
    if (remainderRatio == 0) {//滑动翻页，需要更新选中状态]
        [self.menuView selectItem:baseIndex animated:YES];
        self.currentPageIndex = baseIndex;
    }else {
        //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
        if (fabs(ratio - self.currentPageIndex) > 1) {
            NSInteger targetIndex = baseIndex;
            if (ratio < self.currentPageIndex) {
                targetIndex = baseIndex + 1;
            }
            [self.menuView selectItem:targetIndex animated:YES];
            
            if (self.quickSwipeBeginPageIndex < 0) {
                self.quickSwipeBeginPageIndex = self.currentPageIndex;
            }
            self.currentPageIndex = targetIndex;
        }
        [self.menuView updateUIWithLeftIndex:baseIndex rightIndex:baseIndex+1 ratio:remainderRatio];
    }
}

- (UIViewController *)getVCAtIndex:(NSInteger)index {
    NSDictionary *dic = self.viewDataSourceArr[index];
    return dic[kViewControllerKey];
}

- (UIScrollView *)getScrollViewAtIndex:(NSInteger)index {
    NSDictionary *dic = self.viewDataSourceArr[index];
    return dic[kScrollViewKey];
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dhx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dhx"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.horizontalCollectionView];
        [self.horizontalCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //REMARK: optimize The console outputs a layout error log about collectionview when back from landscape viewcontroller
    if (CGSizeEqualToSize(self.originalSize, CGSizeZero)) {
        self.originalSize = tableView.frame.size;
    }
    
    return self.originalSize.height - [self.hxdataSource menuHeightInUpDownUnionScrollView:self] - self.customHoverTopMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.hxdataSource menuHeightInUpDownUnionScrollView:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.menuView.frame = CGRectMake(0, 0, tableView.frame.size.width, [self.hxdataSource menuHeightInUpDownUnionScrollView:self]);
    return self.menuView;
}


//noti: the two method below is the key of swipe smoothly like silk
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.horizontalCollectionView]) {
        if(scrollView.isTracking || scrollView.isDecelerating) {//用户滚动引起的contentOffset变化才处理
            [self adjustContentViewOffset];
            [self collectionViewContentOffsetDidChanged:scrollView.contentOffset];
        }
        return;
    }
    
    
    if (self.originalOrientation != [UIApplication sharedApplication].statusBarOrientation) {
        return;
    }
    
    
    CGFloat cirticalContentOffset = self._criticlalOffset;
    
    UIScrollView *currentSubScrollView = [self.hxdataSource coreScrollViewInUpDownUnionScrollView:self viewAtIndex:self.currentPageIndex];
    if (currentSubScrollView != nil && currentSubScrollView.contentOffset.y > 0) {
        self.contentOffset = CGPointMake(0, cirticalContentOffset);
    }
    
    if (scrollView.contentOffset.y < cirticalContentOffset) {
        currentSubScrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y > cirticalContentOffset && currentSubScrollView.contentOffset.y == 0) {
        self.contentOffset = CGPointMake(0, cirticalContentOffset);
    }
    
    if ([self.hxdelegate respondsToSelector:@selector(upDownUnionScrollView:contentOffsetY:allowMaximumContentOffsetY:)]) {
        [self.hxdelegate upDownUnionScrollView:self contentOffsetY:self.contentOffset.y allowMaximumContentOffsetY:cirticalContentOffset];
    }
}

#pragma mark UITableViewDelegate
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hxdataSource numberOfViewInUpDownUnionScrollView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self getVCAtIndex:indexPath.item];
    UIScrollView     *scrollview = [self getScrollViewAtIndex:indexPath.item];
    
    
    NSString *identifier = [NSString stringWithFormat:@"%@item_%@",kPagingCellIdentifier, @(indexPath.item)];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIView *content = (UIView *)([cell.contentView viewWithTag:kCellTag]);
    if(!content)
    {
        if (vc) {
            [self.associatedVC addChildViewController:vc];
            [cell.contentView addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
            vc.view.tag = kCellTag;
        }
        else {
            [cell.contentView addSubview:scrollview];
            [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
            scrollview.tag = kCellTag;
        }
        
        
        if(indexPath.item == 0) {
            
            if (vc && ![self.associatedVC shouldAutomaticallyForwardAppearanceMethods]) {
                [vc beginAppearanceTransition:YES animated:YES];
                [vc endAppearanceTransition];
            }
            
        }
    }
    
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}


#pragma mark HXIndicatorMenuViewDelegate
- (void)indicatorMenuView:(UIView<HXUpDownUnionScrollViewMenuViewDelegate> *)indicatorMenuView didSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (self.currentPageIndex != index) {
        
        NSInteger oldPageIndex = self.currentPageIndex;
        self.currentPageIndex = index;
        
        [self adjustContentViewOffset];
        
        if (!self.horizontalCollectionView.isDragging) {//用户拖动时不调整
            [self.horizontalCollectionView setContentOffset:CGPointMake(index * self.horizontalCollectionView.frame.size.width, self.horizontalCollectionView.contentOffset.y) animated:animated];
        }
        
        
        if ([self.hxdelegate respondsToSelector:@selector(upDownUnionScrollView:didSelectItemAtIndex: deselectItemAtIndex:)]) {
            [self.hxdelegate upDownUnionScrollView:self didSelectItemAtIndex:index deselectItemAtIndex:oldPageIndex];
        }
        
        if (![self.associatedVC shouldAutomaticallyForwardAppearanceMethods]) {
            UIViewController *appearVC = [self getVCAtIndex:index];
            if (appearVC) {
                [appearVC beginAppearanceTransition:YES animated:YES];
            }
            
            
            NSInteger disappearIndex = self.quickSwipeBeginPageIndex >= 0 ? self.quickSwipeBeginPageIndex : oldPageIndex;
            UIViewController *disappearVC = [self getVCAtIndex:disappearIndex];
            [disappearVC beginAppearanceTransition:NO animated:YES];
            
            [appearVC endAppearanceTransition];
            [disappearVC endAppearanceTransition];
        }
        
        
        
    }
    self.quickSwipeBeginPageIndex = -1;
}

#pragma mark - Setter And Getter
- (UICollectionView *)horizontalCollectionView
{
    if (!_horizontalCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing          = 0.0;
        layout.minimumInteritemSpacing     = 0.0;
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        
        _horizontalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _horizontalCollectionView.bounces = NO;
        _horizontalCollectionView.backgroundColor                = [UIColor whiteColor];
        _horizontalCollectionView.dataSource                     = self;
        _horizontalCollectionView.delegate                       = self;
        _horizontalCollectionView.pagingEnabled                  = YES;
        _horizontalCollectionView.showsHorizontalScrollIndicator = NO;
        _horizontalCollectionView.scrollsToTop                   = NO;
        
    }
    return _horizontalCollectionView;
}


- (UIView<HXUpDownUnionScrollViewMenuViewDelegate> *)menuView {
    if (!_menuView ) {
        
        if ([self.hxdataSource respondsToSelector:@selector(customMenuViewInUpDownUnionScrollView:)]) {
            _menuView = [self.hxdataSource customMenuViewInUpDownUnionScrollView:self];
            if ([_menuView respondsToSelector:@selector(setUnionDelegate:)]) {
                _menuView.unionDelegate = self;
            }
            else if([_menuView respondsToSelector:@selector(setDelegate:)]) {
                _menuView.delegate = self;
            }
            return _menuView;
        }
        
        NSArray *titles;
        if ([self.hxdataSource respondsToSelector:@selector(pageTitlesInUpDownUnionScrollView:)]) {
            titles = [self.hxdataSource pageTitlesInUpDownUnionScrollView:self];
        }
        if (!titles.count) {
            return nil;
        }
        
        UIColor *selectedColor = [UIColor redColor];
        if ([self.hxdataSource respondsToSelector:@selector(selectedMenuColorInUpDownUnionScrollView:)]) {
            selectedColor = [self.hxdataSource selectedMenuColorInUpDownUnionScrollView:self];
        }
        
        UIColor *normalColor = [UIColor grayColor];
        if ([self.hxdataSource respondsToSelector:@selector(normalMenuColorInUpDownUnionScrollView:)]) {
            normalColor = [self.hxdataSource normalMenuColorInUpDownUnionScrollView:self];
        }
        
        UIColor *sliderColor = [UIColor redColor];
        if ([self.hxdataSource respondsToSelector:@selector(sliderColorInUpDownUnionScrollView:)]) {
            sliderColor = [self.hxdataSource sliderColorInUpDownUnionScrollView:self];
        }
        
        CGFloat sliderWidth = 44;
        if ([self.hxdataSource respondsToSelector:@selector(sliderWidthInUpDownUnionScrollView:)]) {
            sliderWidth = [self.hxdataSource sliderWidthInUpDownUnionScrollView:self];
        }
        
        CGFloat sliderCornerRadius = 2;
        if ([self.hxdataSource respondsToSelector:@selector(sliderCornerRadiusInUpDownUnionScrollView:)]) {
            sliderCornerRadius = [self.hxdataSource sliderCornerRadiusInUpDownUnionScrollView:self];
        }
        
        CGFloat sliderHeight = 2;
        if ([self.hxdataSource respondsToSelector:@selector(sliderHeightMarginInUpDownUnionScrollView:)]) {
            sliderHeight = [self.hxdataSource sliderHeightMarginInUpDownUnionScrollView:self];
        }
        
        CGFloat sliderBottomMargin = 2;
        if ([self.hxdataSource respondsToSelector:@selector(sliderBottomMarginInUpDownUnionScrollView:)]) {
            sliderBottomMargin = [self.hxdataSource sliderHeightMarginInUpDownUnionScrollView:self];
        }
        
        
        SliderStyle sliderStyle = SliderStyleNormal;
        if ([self.hxdataSource respondsToSelector:@selector(sliderStyleInUpDownUnionScrollView:)]) {
            sliderStyle = [self.hxdataSource sliderStyleInUpDownUnionScrollView:self];
        }
        
        BOOL hiddenBottomLine = NO;
        if ([self.hxdataSource respondsToSelector:@selector(menuBottomLineHiddenUpDownUnionScrollView:)]) {
            hiddenBottomLine = [self.hxdataSource menuBottomLineHiddenUpDownUnionScrollView:self];
        }
        
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        if ([self.hxdataSource respondsToSelector:@selector(menuFontInUpDownUnionScrollView:)]) {
            titleFont = [self.hxdataSource menuFontInUpDownUnionScrollView:self];
        }

        
        HXIndicatorMenuView *menuView = [[HXIndicatorMenuView alloc] initWithBtnTitleArray:titles sliderColor:sliderColor normalBtnColor:normalColor selectedBtnColor:selectedColor btnFont:titleFont];
        menuView.sliderWidth        = sliderWidth;
        menuView.sliderHeight       = sliderHeight;
        menuView.sliderBottomMargin = sliderBottomMargin;
        
        menuView.sliderCornerRadius = sliderCornerRadius;
        menuView.sliderStyle        = sliderStyle;
        menuView.hiddenBottomLine   = hiddenBottomLine;
        menuView.delegate           = self;
        _menuView                   = menuView;
    }
    return _menuView;
}

- (NSMutableArray *)scrollViewsArr {
    if (!_scrollViewsArr) {
        _scrollViewsArr = [[NSMutableArray alloc] init];
    }
    return _scrollViewsArr;
}

- (NSMutableArray *)viewDataSourceArr {
    if (!_viewDataSourceArr) {
        _viewDataSourceArr = [[NSMutableArray alloc] init];
    }
    return _viewDataSourceArr;
}

#pragma mark - Dealloc
- (void)dealloc {
    [self removeScrollViewsObserver];
    if (self.addHeadFrameObserver) {
        [self.tableHeaderView removeObserver:self forKeyPath:@"frame"];
    }
}

@end
