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
        self.mininumWidth = 20;
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
    self.viewWidth = MAX(self.mininumWidth, [tempLB sizeThatFits:CGSizeMake(1000, self.viewHeight)].width);
}
@end
