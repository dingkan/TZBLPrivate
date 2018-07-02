//
//  UIView+HCSXTopVc.m
//  XCSX
//
//  Created by hcsx on 2017/8/23.
//  Copyright © 2017年 hcsx. All rights reserved.
//

#import "UIView+HCSXTopVc.h"

@implementation UIView (HCSXTopVc)
- (UINavigationController *)getNav{
    UINavigationController *result = nil;
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            result = (UINavigationController *)nextResponder;
        }
    }
    
    return result;
}

@end
