//
//  UIViewControllerTestable.m
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

#import "UIViewControllerTestable.h"

#import "NSObjectTestable.h"

@implementation UIViewController (UIViewControllerTestable)

/**
 Called by the Obj-C runtime when this module is loaded to automatically initialize UIViewControllerTestable.
 */
+ (void) load
{
    [self initializeTestableFromObjC];
}

@end
