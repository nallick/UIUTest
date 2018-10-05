//
//  UIGestureRecognizerSimulation.swift
//  UIUTestExample
//
//  Created by Tyler Thompson on 10/5/18.
//  Copyright © 2018 Purgatory Design. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    public typealias TargetActionInfo = [(target: AnyObject, action: Selector)]
    
    public func getTargetInfo() -> TargetActionInfo {
        var targetsInfo: TargetActionInfo = []
        
        if let targets = self.value(forKeyPath: "_targets") as? [NSObject] {
            for target in targets {
                // Getting selector by parsing the description string of a UIGestureRecognizerTarget
                let selectorString = String.init(describing: target).components(separatedBy: ", ").first!.replacingOccurrences(of: "(action=", with: "")
                let selector = NSSelectorFromString(selectorString)
                
                // Getting target from iVars
                let targetActionPairClass: AnyClass = NSClassFromString("UIGestureRecognizerTarget")!
                let targetIvar: Ivar = class_getInstanceVariable(targetActionPairClass, "_target")!
                let targetObject: AnyObject = object_getIvar(target, targetIvar) as AnyObject
                
                targetsInfo.append((target: targetObject, action: selector))
            }
        }
        
        return targetsInfo
    }
    
    public func simulateTouch() {
        let targetsInfo = self.getTargetInfo()
        for info in targetsInfo {
            info.target.performSelector(onMainThread: info.action, with: nil, waitUntilDone: true)
        }
    }
    
}
