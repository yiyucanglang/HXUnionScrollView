//
//  HXIndicatorMemuItemView.m
//  ParentDemo
//
//  Created by James on 2019/10/12.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXIndicatorMemuItemView.h"

#import "HXCommonIndicatorMenuItemModel.h"


@interface HXIndicatorMemuItemView()
@property (nonatomic, strong) UILabel  *titleLB;

@end

@implementation HXIndicatorMemuItemView

#pragma mark - Life Cycle
- (void)UIConfig {
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - System Method

#pragma mark - Public Method
- (void)bindingModel:(HXCommonIndicatorMenuItemModel *)dataModel {
    [super bindingModel:dataModel];
    
    dataModel.associatedItemView = (UIView<HXCommonIndicatorMenuItemViewDeleagte> *)self;
    
    self.titleLB.text = dataModel.title;
    self.titleLB.font = dataModel.btnFont;
    if (dataModel.selected) {
        self.titleLB.textColor = dataModel.selectColor;
        self.titleLB.transform = CGAffineTransformMakeScale(MAX(1, dataModel.scale), MAX(1, dataModel.scale));
    }
    else {
        self.titleLB.textColor = dataModel.normalColor;
        self.titleLB.transform= CGAffineTransformIdentity;
    }
}

- (void)updateColor:(UIColor *)color scale:(CGFloat)scale {
    self.titleLB.textColor = color;
    self.titleLB.transform = CGAffineTransformMakeScale(MAX(1, scale), MAX(1, scale));
}

#pragma mark - Override

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:16];
        _titleLB.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
    return _titleLB;
}



#pragma mark - Dealloc

@end
