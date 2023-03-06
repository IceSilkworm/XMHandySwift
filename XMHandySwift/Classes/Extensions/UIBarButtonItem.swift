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
public typealias ActionCompletionHandler = () -> Void

public extension UINavigationItem {
    //left bar
    @discardableResult
    func leftButtonAction(_ image: UIImage?, _ offSet: CGFloat = 10.0, action:@escaping ActionCompletionHandler) -> UIBarButtonItem {
        let wrapper = NavClosureWrapper(callback: action)
        let backBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: wrapper, action: #selector(NavClosureWrapper.invoke))
        objc_setAssociatedObject(self, ClosureKeys.PopBackActionKey!, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        backBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -offSet, bottom: 0, right: offSet)
        self.leftBarButtonItem = backBarButtonItem
        return backBarButtonItem
    }
    
    //right bar
    @discardableResult
    func rightButtonAction(_ image: UIImage, action:@escaping (_ button: UIButton) -> Void) -> UIButton {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        button.imageView?.contentMode = .scaleAspectFit;
        button.contentHorizontalAlignment = .right
        button.tappedAction(forControlEvents: .touchUpInside, withCallback: {
            action(button)
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -10 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
        return button
    }
}

private class NavClosureWrapper : NSObject {
    let _callback : () -> Void
    init(callback : @escaping ActionCompletionHandler) {
        _callback = callback
    }
    
    @objc open func invoke() {
        _callback()
    }
}


private extension UINavigationItem {
    
    struct ClosureKeys {
        static let PopBackActionKey = UnsafeRawPointer.init(bitPattern: "PopBackActionKey".hashValue)
    }
}

extension UIControl {
    
    private struct ClosureKeys {
        static let TappedActionKey = UnsafeRawPointer.init(bitPattern: "TappedActionKey".hashValue)
    }
    
    fileprivate func tappedAction(forControlEvents events: UIControl.Event, withCallback callback: @escaping () -> Void) {
        let wrapper = NavClosureWrapper(callback: callback)
        addTarget(wrapper, action:#selector(NavClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, ClosureKeys.TappedActionKey!, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
