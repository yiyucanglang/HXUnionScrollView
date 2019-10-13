//
//  HXCommonIndicaMenuItemModel.m
//  ParentDemo
//
//  Created by James on 2019/10/13.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXCommonIndicatorMenuItemModel.h"

@implementation HXCommonIndicatorMenuItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewClassName = @"HXIndicatorMemuItemView";
    }
    return self;
}

- (void)autoCalculateWidth {
    static UILabel *tempLB;
    if (!tempLB) {
        tempLB = [[UILabel alloc] init];;
    }
    tempLB.text = self.title;
    tempLB.font = self.btnFont;
    self.viewWidth = MAX(20, [tempLB sizeThatFits:CGSizeMake(1000, self.viewHeight)].width);
}
@end
