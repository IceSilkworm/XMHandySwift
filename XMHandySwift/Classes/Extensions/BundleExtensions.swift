//
//  BundleExtensions.swift
//  EZSwiftExtensions
//
//  Created by chenjunsheng on 15/11/25.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

#if os(iOS) || os(tvOS)

public extension NSObject {
    
    var className: String {
        return type(of: self).className
    }
    
    static var className: String {
        return String(describing: self)
    }
}

#endif

public extension Bundle {

    #if os(iOS) || os(tvOS)
    /// EZSE: load xib
    //  Usage: Set some UIView subclass as xib's owner class
    //  Bundle.loadNib("ViewXibName", owner: self) //some UIView subclass
    //  self.addSubview(self.contentView)
    class func loadNib(_ name: String, owner: AnyObject!) {
        _ = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?[0]
    }

    /// EZSE: load xib
    /// Usage: let view: ViewXibName = Bundle.loadNib("ViewXibName")
    class func loadNib<T>(_ name: String) -> T? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?[0] as? T
    }
    
    #endif
}

public protocol StoryboardInitializes {
    static var storyboardIdentifier: String { get }
}

public extension StoryboardInitializes where Self: UIViewController {
    
    #if os(iOS) || os(tvOS)

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
    #endif
}
