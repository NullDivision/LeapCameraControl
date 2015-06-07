//
//  UINavigationController+SafePushing.h
//  XMTrade
//
//  Created by Maxim Guzun on 3/25/14.
//
//

#import <Foundation/Foundation.h>

@interface UINavigationController(SafePushing)
- (id)navigationLock; ///< Obtain "lock" for pushing onto the navigation controller
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Uses a horizontal slide transition. Has no effect if the view controller is already in the stack. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops view controllers until the one specified is on top. Returns the popped controllers. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops until there's only a single view controller left on the stack. Returns the popped controllers. Has no effect if navigationLock is not the current lock.
@end
