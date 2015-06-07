//
//  UINavigationController+SafePushing.m
//  XMTrade
//
//  Created by Maxim Guzun on 3/25/14.
//
//

@implementation UINavigationController (SafePushing)
//------------------------------------------------------------------------------------------------------------------------
- (id)navigationLock
{
    return self.topViewController;
}
//------------------------------------------------------------------------------------------------------------------------
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock) 
        [self pushViewController:viewController animated:animated];
}
//------------------------------------------------------------------------------------------------------------------------
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToRootViewControllerAnimated:animated];
    return @[];
}
//------------------------------------------------------------------------------------------------------------------------
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToViewController:viewController animated:animated];
    return @[];
}
//------------------------------------------------------------------------------------------------------------------------
@end
