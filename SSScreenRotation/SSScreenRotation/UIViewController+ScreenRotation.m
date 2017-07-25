//
//  UIViewController+ScreenRotation.m
//  SSScreenRotation
//
//  Created by swifterfit on 2017/7/25.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "UIViewController+ScreenRotation.h"
#import <objc/runtime.h>

@implementation UIViewController (ScreenRotation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ss_swizzlingOriSel:@selector(shouldAutorotate) cusSel:@selector(ss_shouldAutorotate)];
        [self ss_swizzlingOriSel:@selector(supportedInterfaceOrientations) cusSel:@selector(ss_supportedInterfaceOrientations)];
    });
}

+ (void)ss_swizzlingOriSel:(SEL)oriSel cusSel:(SEL)cusSel {
    Class class = [self class];
    Method oriMethod = class_getInstanceMethod(class, oriSel);
    Method cusMethod = class_getInstanceMethod(class, cusSel);
    BOOL addSuccess = class_addMethod(class, oriSel, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));

    addSuccess ? class_replaceMethod(class, cusSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod)) : method_exchangeImplementations(oriMethod, cusMethod);
}

- (BOOL)ss_shouldAutorotate {
    if ([self isKindOfClass:[UITabBarController class]]) {
        return ((UITabBarController *)self).selectedViewController.shouldAutorotate;
    }
    if ([self isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)self).viewControllers.lastObject.shouldAutorotate;
    }
    if ([self isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
        return YES;
    }
    if (self.ss_autorotate) {
        return YES;
    }
    return NO;
}

- (UIInterfaceOrientationMask)ss_supportedInterfaceOrientations {
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController supportedInterfaceOrientations];
    }
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).viewControllers.lastObject supportedInterfaceOrientations];
    }
    if ([self isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    if (self.ss_autorotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setSs_autorotate:(BOOL)ss_autorotate {
    objc_setAssociatedObject(self, @selector(ss_autorotate), @(ss_autorotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ss_autorotate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
