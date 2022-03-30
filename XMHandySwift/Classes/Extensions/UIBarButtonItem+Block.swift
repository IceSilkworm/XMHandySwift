//
//  UIBarButtonItem+Block.swift
//  
//
//  Created by on 2017/8/7.
//  Copyright © 2017年. All rights reserved.
//

import Foundation
import UIKit

/// PDF image size : 20px * 20px is perfect one
public typealias ActionHandler = () -> Void

public extension UINavigationItem {
    //left bar
    func leftButtonAction(_ image: UIImage?, action:@escaping ActionHandler) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .left
        button.tappedAction(forControlEvents: .touchUpInside, withCallback: {
            action()
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.leftBarButtonItems = [gapItem, barButton]
    }
    
    //right bar
    @discardableResult
    func rightButtonAction(_ image: UIImage, action:@escaping (_ button: UIButton) -> Void) -> UIButton {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .right
        button.tappedAction(forControlEvents: .touchUpInside, withCallback: {
            action(button)
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
        return button
    }
}

private class NavClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping () -> Void) {
        _callback = callback
    }
    
    @objc open func invoke() {
        _callback()
    }
}

extension UIControl {
    
    private struct ClosureKeys {
        static let leftButtonActionKey = UnsafeRawPointer.init(bitPattern: "leftButtonActionKey".hashValue)
    }
    
    fileprivate func tappedAction(forControlEvents events: UIControl.Event, withCallback callback: @escaping () -> Void) {
        let wrapper = NavClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(NavClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, ClosureKeys.leftButtonActionKey!, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
