//
//  UIView+GestureBlock.swift
//  
//
//  Created by on 2017/9/5.
//  Copyright © 2017年. All rights reserved.
//

import Foundation
import UIKit

fileprivate class ClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping () -> Void) {
        _callback = callback
    }
    
    @objc func invoke() {
        _callback()
    }
}

fileprivate var ClosureWrapperAssociatedClosure: UInt8 = 1

public extension UIView {
    /// Adds a tap gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func tapped(callback: @escaping () -> Void) -> UITapGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = ClosureWrapper(callback: callback)
        let gesture = UITapGestureRecognizer.init(target: wrapper, action: #selector(ClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &ClosureWrapperAssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a long press gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func longPressed(callback: @escaping () -> Void) -> UILongPressGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = ClosureWrapper(callback: callback)
        let gesture = UILongPressGestureRecognizer.init(target: wrapper, action: #selector(ClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &ClosureWrapperAssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a pinch press gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func pinched(callback: @escaping () -> Void) -> UIPinchGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = ClosureWrapper(callback: callback)
        let gesture = UIPinchGestureRecognizer.init(target: wrapper, action: #selector(ClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &ClosureWrapperAssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a pan gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func panned(callback: @escaping () -> Void) -> UIPanGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = ClosureWrapper(callback: callback)
        let gesture = UIPanGestureRecognizer.init(target: wrapper, action: #selector(ClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &ClosureWrapperAssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
    
    /// Adds a rotation gesture to the view with a block that will be invoked whenever
    ///
    /// - parameter callback: callback Invoked whenever the gesture's state changes.
    ///
    /// - returns: The gesture.
    @discardableResult
    func rotated(callback: @escaping () -> Void) -> UIRotationGestureRecognizer {
        self.isUserInteractionEnabled = true
        let wrapper = ClosureWrapper(callback: callback)
        let gesture = UIRotationGestureRecognizer.init(target: wrapper, action: #selector(ClosureWrapper.invoke))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &ClosureWrapperAssociatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gesture
    }
}

extension UIView {
    
    struct HandlerTapGestureKeys {
        static let kActionHandlerTapGestureKey = UnsafeRawPointer.init(bitPattern: "kActionHandlerTapGestureKey".hashValue)
        static let kActionHandlerTapBlockKey = UnsafeRawPointer.init(bitPattern: "kActionHandlerTapBlockKey".hashValue)
    }
    
    func addTapActionWithBlock(block:@escaping (_ gesture: UIGestureRecognizer) -> ()) {
        var gesture = objc_getAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapGestureKey!)
        if gesture == nil {
            gesture = UITapGestureRecognizer(target: self, action: #selector(handleActionForTapGesture(_:)))
            self.addGestureRecognizer(gesture as! UITapGestureRecognizer)
            objc_setAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapGestureKey!, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        objc_setAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapBlockKey!, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    @objc func handleActionForTapGesture(_ gesture: UIGestureRecognizer) -> () {
        if gesture.state == .recognized {
            let block = objc_getAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapBlockKey!) as? ((_: UIGestureRecognizer) -> ())
            block?(gesture)
        }
    }
    
    func removeTapAction() {
        let gesture = objc_getAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapGestureKey!)
        if gesture != nil {
            self.removeGestureRecognizer(gesture as! UIGestureRecognizer)
        }
        objc_setAssociatedObject(self, HandlerTapGestureKeys.kActionHandlerTapGestureKey!, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

