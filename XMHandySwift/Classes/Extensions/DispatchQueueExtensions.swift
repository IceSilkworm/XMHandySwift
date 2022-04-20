//
//  DispatchQueueExtensions.swift
//  
//
//  Created by on 2017/9/5.
//  Copyright © 2017年. All rights reserved.
//

import Foundation

// stolen from Kingfisher: https://github.com/onevcat/Kingfisher/blob/master/Sources/ThreadHelper.swift

public func dispatch_async_safely_to_main_queue(_ block: @escaping ()->()) {
    dispatch_async_safely_to_queue(DispatchQueue.main, block)
}

// This methd will dispatch the `block` to a specified `queue`.
// If the `queue` is the main queue, and current thread is main thread, the block
// will be invoked immediately instead of being dispatched.
public func dispatch_async_safely_to_queue(_ queue: DispatchQueue, _ block: @escaping ()->()) {
    if queue === DispatchQueue.main && Thread.isMainThread {
        block()
    } else {
        queue.async {
            block()
        }
    }
}

//The free function dispatch_once is no longer available in Swift. In Swift, you can use lazily initialized globals or static properties and get the same thread-safety and called-once guarantees as dispatch_once provided.
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        DispatchQueue.once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if DispatchQueue._onceTracker.contains(token) {
            return
        }
        
        DispatchQueue._onceTracker.append(token)
        block()
    }
}



//添加了关键词@escaping，这里闭包函数的生命周期不可预知，上面省略的self 就有必要明确地添加来提醒self已经被捕捉，循环引用的风险就在眼前。
//下面是使用逃逸闭包的2个场景：
//异步调用: 如果需要调度队列中异步调用闭包， 这个队列会持有闭包的引用，至于什么时候调用闭包，或闭包什么时候运行结束都是不可预知的。
//存储: 需要存储闭包作为属性，全局变量或其他类型做稍后使用。

//*****************************************************************
// MARK: - Helper Functions
//*****************************************************************

public func dispatchAsyncAfter(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

///
/// - Parameters:
public func synchronized(_ lock: AnyObject,dispose: ()->()) {
    objc_sync_enter(lock)
    dispose()
    objc_sync_exit(lock)
}

//*****************************************************************
// MARK: - DispatchQueue Test Helpers
// https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20160613/002280.html
public extension DispatchQueue {
    class var currentLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
