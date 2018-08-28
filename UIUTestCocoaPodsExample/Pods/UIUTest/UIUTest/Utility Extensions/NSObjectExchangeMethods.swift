//
//  NSObjectExchangeMethods.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import Foundation

public extension NSObject
{
    /// Exchange (i.e., swizzle) two methods of this class.
    ///
    /// - Parameters:
    ///   - selector1: the selector of the first method
    ///   - selector2: the selector of the second method
    ///
    /// - Note: Swift class methods (i.e., not imported from Obj-C) my be declared `dynamic`.
    ///
    public class func exchangeMethods(_ selector1: Selector, _ selector2: Selector) {
        let method1 = class_getInstanceMethod(self, selector1)
        let method2 = class_getInstanceMethod(self, selector2)
        method_exchangeImplementations(method1!, method2!)
    }
}
