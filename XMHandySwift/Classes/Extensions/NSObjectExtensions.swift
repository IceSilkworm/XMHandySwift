//
//  NSObject+Extensions.swift
//  Breakfast
//
//  This file is from a dynamic framework I created called Breakfast. I included the
//  files here so you didn't have to install another Cocoapod to use and test out
//  this library. As such, this file may not be maintained as well, so use it at
//  your own risk.
//
//  SwiftSVG is one of the many great tools that are a part of Breakfast. If you're
//  looking for a great start to your next Swift project, check out Breakfast.
//  It contains classes and helper functions that will get you started off right.
//  https://github.com/mchoe/Breakfast
//
//
//  Copyright (c) 2015 Michael Choe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//  http://www.github.com/mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

extension NSObject {
    
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    func propertyNames() -> [String] {
        var results = [String]();
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self.classForCoder;
        let properties = class_copyPropertyList(myClass, &count);
        
        // iterate each objc_property_t struct
        for i in 0..<count {
            let property = properties?[Int(i)];
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property!);
            
            // convert the c string into a Swift string
            let name = String(cString: cname);
            results.append(name);
        }
        
        // release objc_property_t structs
        free(properties);
        
        return results;
    }
    
    func classNameAsString() -> String {
        
        let thisClass: AnyClass = self.classForCoder
        let classString = NSStringFromClass(thisClass)
        return classString
    }

    /// - Parameter className: className
    func classFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            // YourProject.className
            let classStringName = appName + "." + className
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}


/// ObjectAssociation
public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}


//  a life of once time
extension NSObject {
    
    private static let association = ObjectAssociation<NSObject>()
    
    private(set) var hasInvoked: NSNumber? {
        get { return NSObject.association[self] as? NSNumber }
        set { NSObject.association[self] = newValue }
    }
    
    func doOnceInALifeTime(_ method: @escaping () -> ()) -> Void {
        
        if self.hasInvoked == nil || self.hasInvoked?.boolValue == false {
            method()
            self.hasInvoked = NSNumber.init(value: true)
        }
    }
}


extension NSObject {
    
    internal static func swizzleMethod(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        } else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}
