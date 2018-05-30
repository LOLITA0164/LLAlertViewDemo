//
//  UIApplication+CurrentCtrl.m
//  GuDaShi
//
//  Created by 骆亮 on 2018/5/16.
//  Copyright © 2018年 CXKJ. All rights reserved.
//

#import "UIApplication+CurrentCtrl.h"

@implementation UIApplication (CurrentCtrl)

-(UIViewController*) currentViewController {
    
    UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findBestViewController:viewController];
}

-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end
